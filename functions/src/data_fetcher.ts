import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

// eslint-disable-next-line @typescript-eslint/no-var-requires
const he = require("he");
// eslint-disable-next-line @typescript-eslint/no-var-requires
const xml2js = require("xml2js");
import cors from "cors";
const corsHandler = cors({origin: true});
import { db } from "./initialize_app";
import { DocumentReference, DocumentSnapshot, QuerySnapshot, Timestamp, collection, doc, getDoc, getDocs, serverTimestamp, setDoc, FieldValue } from "firebase/firestore";
import { AdvisorEntry, DblpPid, GraduatedLabMemberEntry, LabMemberEntry, ResearcherEntry } from "./db_types";

const DOCTORATE_STUDENTS_URL = "https://ics.uci.edu/~theory/doctorates.html";
const THEORY_URL = "https://ics.uci.edu/~theory/";

const DBLP_AUTHOR_LOOKUP_URL = "https://dblp.org/search/author/api?h=1&format=json&c=1&q=";
const DBLP_AUTHOR_URL = "https://dblp.org/pid/";


// HTML Parsing utilities
interface NameUrlPair {
	name: string;
	url?: string;
}

const cleanHtml = (html: string): string =>
	(he.decode(html) as string)
		.replace(/<[^>]*>?/gm, "")
		.replace(/\s+/g, " ")
		.trim();

const getNameAndUrl = (html: string): NameUrlPair => {
	const nameMatch = (he.decode(html) as string).match(/<a href="(.*?)">(.*?)<\/a>/u) ||
				   (he.decode(html) as string).match(/<b>(.*?)<\/b>/u);
	
	if (!nameMatch) {
		return { name: cleanHtml(html) };
	}

	return {
		name: cleanHtml(nameMatch[2] || nameMatch[1]),
		url: nameMatch[1] && nameMatch[1] !== nameMatch[2] ? nameMatch[1] : undefined,
	};
};

// DBLP utilities
interface DblpResponse {
	result?: {
		hits: {
			hit?: Array<{
				info: {
					author: string;
					url: string;
				};
			}>;
		};
	};
}

interface DblpXmlResponse {
	dblpperson?: {
		coauthors?: [{
			co: Array<{
				na: Array<{
					$: {
						pid: string;
					};
				}>;
			}>;
		}];
	};
}

const fetchWithErrorHandling = async (url: string, name?: string) => {
	try {
		const response = await fetch(url);
		const data = await response.text();
		if (!data) {
			throw new Error(`Failed to fetch data${name ? " for ${name}" : ""}`);
		}
		return data;
	} catch (error) {
		logger.error(`Failed to fetch data${name ? " for ${name}" : ""}:`, error);
		throw error;
	}
};

const fetchDblpPid = async (name: string): Promise<string> => {
	logger.info("Fetching DBLP PID for", name);
	
	try {
		const response = await fetch(DBLP_AUTHOR_LOOKUP_URL + name);
		const data = await response.json() as DblpResponse;
		
		const hit = data?.result?.hits?.hit?.[0];
		if (hit) {
			const hitName = hit.info.author;
			if (hitName !== name) {
				logger.warn("Name mismatch:", name, "vs.", hitName);
				return "";
			}
			return hit.info.url.split("pid/")[1];
		}
		
		logger.warn("DBLP PID not found for", name);
		return "";
	} catch (error) {
		logger.error("Failed to fetch DBLP PID:", error);
		return "";
	}
};

// Update the fetchCollaborators function to use the new utilities
const fetchCollaborators = async (dblpPid: string): Promise<string[]> => {
	const authorXmlUrl = DBLP_AUTHOR_URL + dblpPid + ".xml";

	try {
		const responseText = await fetchWithErrorHandling(authorXmlUrl, dblpPid);
		const parser = new xml2js.Parser();
		
		const parsed = await new Promise<DblpXmlResponse>((resolve, reject) => {
			parser.parseString(responseText, (err: Error | null, result: DblpXmlResponse) => {
				if (err) {
					logger.error("Failed to parse XML:", err, dblpPid);
					reject(err);
				} else {
					resolve(result);
				}
			});
		});

		const coauthors = parsed.dblpperson?.coauthors;
		return coauthors && coauthors.length > 0 
			? coauthors[0].co.map(entry => entry.na[0]["$"].pid)
			: [];
	} catch (error) {
		logger.error("An error occurred:", error, dblpPid);
		throw error;
	}
};

const rcontains = (list: DocumentReference[], ref: DocumentReference) => list.some(item => item.path === ref.path);

const getDoctorateStudents = async () => {
	const content = await fetch(DOCTORATE_STUDENTS_URL)
		.then(response => response.text())
		.catch(error => logger.error("Failed to fetch data:", error));

	if (!content) {
		throw new Error("Failed to fetch data");
	}

	const tableRows = content.split("<tr>");
	const students = [];
	let previousYear = 0;
	for (let i = 2; i < tableRows.length; i++) {
		const row = tableRows[i];
		const columns = row.split("<td>");
		const yearColumn = columns[1].split("</td>")[0];
		const nameAndUrl = getNameAndUrl(columns[2].split("</td>")[0]);
		const student: Omit<GraduatedLabMemberEntry, "advisors" | "dblpPid" | "lastUpdate" | "collaborators"> & { advisors: string[] } = {
			name: nameAndUrl.name,
			advisors: columns[3].split("</td>")[0].split(" / ").map(cleanHtml),
			thesisTitle: cleanHtml(columns[4].split("</td>")[0]),
			url: nameAndUrl.url,
			year: parseInt(yearColumn) || previousYear,
			hasDoctorate: true,
		}
		previousYear = student.year;
		students.push(student);
	}

	return students;
}

const addStudents = async (students: Omit<LabMemberEntry, "advisors" | "dblpPid" | "lastUpdate" | "collaborators">[], ulMatches: string, arePostDocs: boolean) => {
	const liMatches = ulMatches.match(/<li>(.*?)<\/li>/sgu);

	if (!liMatches) {
		throw new Error("Failed to parse data");
	}

	for (const liMatch of liMatches) {
		const nameMatch = liMatch.match(/<b>(.*?)<\/b>/su);
		if (!nameMatch) {
			throw new Error("Failed to parse data");
		}

		const nameAndUrl = getNameAndUrl(nameMatch[1]);
		const student: Omit<LabMemberEntry, "advisors" | "dblpPid" | "lastUpdate" | "collaborators"> = {
			name: nameAndUrl.name,
			url: nameAndUrl.url,
			hasDoctorate: arePostDocs,
		};

		students.push(student);
	}
}

const getCurrentStudents = async () => {
	const content = await fetch(THEORY_URL)
		.then(response => response.text())
		.catch(error => logger.error("Failed to fetch data:", error));
	
	if (!content) {
		throw new Error("Failed to fetch data");
	}

	const ulMatch = content.match(/<ul>(.*?)<\/ul>/sgu);
	if (!ulMatch || ulMatch.length < 4) {
		throw new Error("Failed to parse data");
	}

	const students: Array<Omit<LabMemberEntry, "advisors" | "dblpPid" | "lastUpdate" | "collaborators">> = [];

	addStudents(students, ulMatch[1], false);
	addStudents(students, ulMatch[3], true);

	return students;
}

const getLabStudents = async () => {
	const doctorateStudents = await getDoctorateStudents();
	const currentStudents = await getCurrentStudents();
	const currentStudentsNoDuplicates = currentStudents.filter(student => !doctorateStudents.some(doctorateStudent => doctorateStudent.name === student.name));
	return [...doctorateStudents, ...currentStudentsNoDuplicates];
}

const getProfessors = async () => {
	const content = await fetch(THEORY_URL)
		.then(response => response.text())
		.catch(error => logger.error("Failed to fetch data:", error));

	if (!content) {
		throw new Error("Failed to fetch web data");
	}

	const ulMatch = content.match(/<ul>(.*?)<\/ul>/sgu);

	if (!ulMatch || ulMatch.length < 3) {
		throw new Error("Failed to parse ul matches");
	}

	const ulContent = ulMatch[0] + ulMatch[2];

	const professors = [];
	const liMatches = ulContent.match(/<li>(.*?)<\/li>/sgu);

	if (!liMatches) {
		throw new Error("Failed to parse li matches");
	}

	for (const liMatch of liMatches) {
		const nameMatch = liMatch.match(/<a href="(.*?)">(.*?)<\/a>/su);
		let title = "";
		
		// Extract title by removing HTML tags and the professor's name
		const liText = cleanHtml(liMatch);
		if (nameMatch) {
			const professorName = cleanHtml(nameMatch[2]);
			title = liText.replace(professorName, "").trim();
			// Remove any leading commas and whitespace
			title = title.replace(/^,\s*/, "");
			// Only keep the first title (before any comma or additional roles)
			title = title.split(/,|\(/)[0].trim();
		}

		// Default to "Professor" if no title is found
		title = title || "Professor";

		if (!nameMatch) {
			const nameMatch = liMatch.match(/<b>(.*?)<\/b>/su);
			if (!nameMatch) {
				throw new Error("Failed to parse name match");
			}

			const professorName = cleanHtml(nameMatch[1]);
			const liText = cleanHtml(liMatch);
			title = liText.replace(professorName, "").trim();
			// Remove any leading commas and whitespace
			title = title.replace(/^,\s*/, "");
			// Only keep the first title (before any comma or additional roles)
			title = title.split(/,|\(/)[0].trim();

			const professor: Omit<AdvisorEntry, "students" | "dblpPid" | "lastUpdate" | "collaborators"> = {
				name: professorName,
				title: title || "Professor",
			};

			professors.push(professor);
		} else {
			const professorName = cleanHtml(nameMatch[2]);
			const liText = cleanHtml(liMatch);
			title = liText.replace(professorName, "").trim();
			// Remove any leading commas and whitespace
			title = title.replace(/^,\s*/, "");
			// Only keep the first title (before any comma or additional roles)
			title = title.split(/,|\(/)[0].trim();

			const professor: Omit<AdvisorEntry, "students" | "dblpPid" | "lastUpdate" | "collaborators"> = {
				name: professorName,
				url: nameMatch[1],
				title: title || "Professor",
			};

			professors.push(professor);
		}
	}

	return professors;
}

const fetchNewCollaborators = async (dblpPid: string, docRef: DocumentReference<ResearcherEntry>, existingCollaborators: DocumentReference<ResearcherEntry>[]) => {
	logger.info("Fetching collaborators for", dblpPid);
	
	const collaborators = await fetchCollaborators(dblpPid);
	const newCollaborators = [];
	for (const collaborator of collaborators) {
		const dblpPidRef = doc(db, "dblp-pids", collaborator.replace("/", "-")) as DocumentReference<DblpPid>;
		const collaboratorDoc = await getDoc(dblpPidRef);
		if (collaboratorDoc.exists() && !rcontains(existingCollaborators, collaboratorDoc.data().researcher)) {
			const researcherRef = collaboratorDoc.data().researcher;
			newCollaborators.push(researcherRef);

			const researcherDoc = await getDoc(researcherRef);
			const existingCollaborators = researcherDoc.data()?.collaborators || [];
			if (!rcontains(existingCollaborators, docRef)) {
				await setDoc(researcherRef, {collaborators: [...existingCollaborators, docRef]}, {merge: true});
			}
		}
	}

	return newCollaborators;
}

// Shared utility functions for researcher updates
interface BaseResearcherEntry {
	name: string;
	url?: string;
	dblpPid?: string;
	lastUpdate?: Timestamp | FieldValue;
	collaborators: DocumentReference<ResearcherEntry>[];
}

interface ExtendedResearcher extends BaseResearcherEntry {
	title?: string;
	hasDoctorate?: boolean;
	thesisTitle?: string;
	year?: number;
}

const updateResearcherDblpInfo = async (
	docRef: DocumentReference<ResearcherEntry>,
	docSnap: DocumentSnapshot<ResearcherEntry>,
	updatedData: Partial<BaseResearcherEntry>,
	forceUpdateCollaborators = false
) => {
	const updatedRecently = docSnap.exists() && (docSnap.data()?.lastUpdate as Timestamp)?.toDate() > new Date(Date.now() - 1000 * 60 * 60 * 24 * 30 * 6);
	const dblpPid = docSnap.exists() && docSnap.data()?.dblpPid ? docSnap.data()?.dblpPid : updatedData.dblpPid;

	if (dblpPid && (!docSnap.exists() || !updatedRecently || forceUpdateCollaborators)) {
		logger.info("Searching for new collaborators for", docRef.id);
		const existingCollaborators = docSnap.exists() ? docSnap.data()?.collaborators || [] : [];
		const newCollaborators = await fetchNewCollaborators(dblpPid, docRef, existingCollaborators);

		if (newCollaborators.length > 0) {
			logger.log("Adding collaborators", newCollaborators.map(collaborator => collaborator.id));
			updatedData.collaborators = [...existingCollaborators, ...newCollaborators];
		}
		return true;
	}
	return false;
}

const updateDblpPidMapping = async (dblpPid: string, researcherRef: DocumentReference<ResearcherEntry>) => {
	if (dblpPid) {
		const dblpPidRef = doc(db, "dblp-pids", dblpPid.replace("/", "-")) as DocumentReference<DblpPid>;
		await setDoc(dblpPidRef, {pid: dblpPid, researcher: researcherRef}, {merge: true});
	}
}

interface ResearcherUpdateOptions<T extends ExtendedResearcher> {
	collection: string;
	getDocId: (name: string) => string;
	transformData: (data: Partial<T>) => Partial<T>;
}

const updateResearcher = async <T extends ExtendedResearcher>(
	researcher: Partial<T>,
	options: ResearcherUpdateOptions<T>
) => {
	const { collection, getDocId, transformData } = options;
	
	if (!researcher.name) {
		throw new Error("Researcher name is required");
	}
	
	logger.info("Checking researcher", researcher.name);
	
	const docRef = doc(db, collection, getDocId(researcher.name)) as DocumentReference<T>;
	const docSnap = await getDoc(docRef);
	const updatedData = transformData(researcher);

	let shouldUpdate = false;
	let forceUpdateCollaborators = false;

	if (!docSnap.exists()) {
		updatedData.name = researcher.name;
		updatedData.dblpPid = await fetchDblpPid(researcher.name);
		updatedData.collaborators = [];
		shouldUpdate = true;
	} else {
		const data = docSnap.data();
		if (!data.dblpPid) {
			const newDblpPid = await fetchDblpPid(researcher.name);
			updatedData.dblpPid = newDblpPid;
			if (data.dblpPid !== newDblpPid) {
				forceUpdateCollaborators = true;
			}
		}
		
		shouldUpdate = Object.entries(updatedData).some(
			([key, value]) => key in data && data[key as keyof T] !== value
		);
	}

	shouldUpdate = shouldUpdate || await updateResearcherDblpInfo(
		docRef as DocumentReference<ResearcherEntry>,
		docSnap as DocumentSnapshot<ResearcherEntry>,
		updatedData,
		forceUpdateCollaborators
	);

	if (shouldUpdate) {
		updatedData.lastUpdate = serverTimestamp();
		await setDoc(docRef, updatedData, { merge: true });
	}

	if (updatedData.dblpPid) {
		await updateDblpPidMapping(
			updatedData.dblpPid,
			docRef as DocumentReference<ResearcherEntry>
		);
	}
	
	return { docRef, updatedData, shouldUpdate };
}

const updateLabProfessors = async () => {
	const professors = await getProfessors();

	for (const professor of professors) {
		await updateResearcher(professor, {
			collection: "advisors",
			getDocId: formatProfessorName,
			transformData: (prof: Partial<ExtendedResearcher>) => ({
				name: prof.name,
				...(prof.url ? { url: prof.url } : {}),
				...(prof.title ? { title: prof.title } : {}),
				students: [],
			}),
		});
	}
}

const updateLabStudents = async () => {
	const students = await getLabStudents();
	
	for (const student of students) {
		const { docRef, shouldUpdate } = await updateResearcher(student, {
			collection: "lab-members",
			getDocId: (name) => name,
			transformData: (stud: Partial<ExtendedResearcher>) => ({
				...(typeof stud.hasDoctorate === "boolean" ? { hasDoctorate: stud.hasDoctorate } : {}),
				...(stud.thesisTitle ? { thesisTitle: stud.thesisTitle } : {}),
				...(stud.year ? { year: stud.year } : {}),
				...(stud.url ? { url: stud.url } : {}),
			}),
		});

		// Handle advisors separately since it's unique to students
		if (shouldUpdate && "advisors" in student) {
			const advisors = student.advisors as string[];
			for (const advisor of advisors) {
				const advisorRef = doc(db, "advisors", advisor) as DocumentReference<AdvisorEntry>;
				const advisorDoc = await getDoc(advisorRef);
				
				if (!advisorDoc.exists()) {
					const advisorDblpPid = await fetchDblpPid(advisor);
					await setDoc(advisorRef, {
						name: advisor,
						lastUpdate: serverTimestamp(),
						students: [docRef],
						dblpPid: advisorDblpPid,
						collaborators: [],
						title: "Professor"
					} as AdvisorEntry);

					await updateDblpPidMapping(advisorDblpPid, advisorRef);
				} else if (!rcontains(advisorDoc.data().students, docRef)) {
					await setDoc(advisorRef, {
						students: [...advisorDoc.data().students, docRef]
					}, { merge: true });
				}
			}
		}
	}
}

// for example: "Thomas A. Standish" should become "T. Standish"
const formatProfessorName = (name: string) => {
	const names = name.split(" ");
	return `${names[0][0]}. ${names[names.length - 1]}`;
}

export const fetchAllResearchers = onRequest(async (request, response) => {
	corsHandler(request, response, async () => {
		const professorSnapshot = await getDocs(collection(db, "advisors")) as QuerySnapshot<AdvisorEntry>;
		const studentSnapshot = await getDocs(collection(db, "lab-members")) as QuerySnapshot<LabMemberEntry>;

		const researcherMap = new Map<string, string>();
		professorSnapshot.docs.forEach(doc => researcherMap.set(doc.ref.path, doc.data().name));
		studentSnapshot.docs.forEach(doc => researcherMap.set(doc.ref.path, doc.data().name));

		const professors = professorSnapshot.docs.map(doc => {
			const professor = doc.data();
			const collaborators = professor.collaborators?.map(collaborator => researcherMap.get(collaborator.path)) || [];
			const students = professor.students?.map(student => researcherMap.get(student.path)) || [];
			return {...professor, collaborators, students};
		});

		const students = studentSnapshot.docs.map(doc => {
			const student = doc.data();
			const advisors = student.advisors?.map(advisor => researcherMap.get(advisor.path)) || [];
			const collaborators = student.collaborators?.map(collaborator => researcherMap.get(collaborator.path)) || [];
			return {...student, advisors, collaborators};
		});

		return response.json({
			professors,
			students,
		});
	});
});

export const updateDatabase = onRequest({
	timeoutSeconds: 540,
}, async (request, response) => {
	corsHandler(request, response, async () => {
		try {
			await updateLabProfessors();
			await updateLabStudents();
			response.send("Database updated");
		} catch (error) {
			logger.error("Error updating database", error);
			response.status(500).send("Error updating database");
		}
	});
});
