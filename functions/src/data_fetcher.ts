import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

const SECOND = 1000;
const MINUTE = 60 * SECOND;
const HOUR = 60 * MINUTE;
const DAY = 24 * HOUR;
// const WEEK = 7 * DAY;
const MONTH = 30 * DAY;

// eslint-disable-next-line @typescript-eslint/no-var-requires
const he = require("he");
// eslint-disable-next-line @typescript-eslint/no-var-requires
const xml2js = require("xml2js");
import cors from "cors";
const corsHandler = cors({origin: true});
import { db } from "./initialize_app";
import { DocumentReference, QuerySnapshot, Timestamp, collection, doc, getDoc, getDocs, serverTimestamp, setDoc, FieldValue, deleteDoc } from "firebase/firestore";
import { AdvisorEntry, DblpPid, GraduatedLabMemberEntry, LabMemberEntry, ResearcherEntry, DblpResponse, DblpPersonXml, ensureArray, convertR_ElementToPublicationEntry, PublicationEntry } from "./db_types";

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

	const nameQuery = name.split(" ").map(word => word + "$").join(" ");

	try {
		const response = await fetch(DBLP_AUTHOR_LOOKUP_URL + nameQuery);
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

const fetchDblpPidMapping = async () => {
	const dblpPids = await getDocs(collection(db, "dblp-pids")) as QuerySnapshot<DblpPid>;
	return new Map(dblpPids.docs.map(doc => [doc.data().pid, doc.data().researcher]));
}

const fetchPapers = async (dblpPid: string, dblpPidMapping: Map<string, DocumentReference<ResearcherEntry>>) => {
	const authorXmlUrl = DBLP_AUTHOR_URL + dblpPid + ".xml";

	try {
		const responseText = await fetchWithErrorHandling(authorXmlUrl, dblpPid);
		const parser = new xml2js.Parser({explicitArray: false});

		const parsed = await new Promise<DblpPersonXml>((resolve, reject) => {
			parser.parseString(responseText, (err: Error | null, result: DblpPersonXml) => {
				if (err) {
					logger.error("Failed to parse XML:", err, dblpPid);
					reject(err);
				} else {
					resolve(result);
				}
			});
		});

		const publications = ensureArray(parsed.dblpperson.r).map(convertR_ElementToPublicationEntry);
		for (const publication of publications) {
			if (!publication) {
				logger.warn("Failed to convert publication:", dblpPid);
				continue;
			}

			publication.authors.forEach(author => {
				if (author.pid && dblpPidMapping.has(author.pid)) {
					publication.researchers = publication.researchers || [];
					publication.researchers.push(dblpPidMapping.get(author.pid) as DocumentReference<ResearcherEntry>);
				}
			});
		}

		return publications.filter(p => p !== null) as PublicationEntry[];
	} catch (error) {
		logger.error("An error occurred:", error, dblpPid);
		throw error;
	}
}

const fetchAllPapers = async (updatedAfter: Timestamp, forcedDblpPids: Set<string>) => {
	const dblpPidMapping = await fetchDblpPidMapping();
	const dblpPids = Array.from(dblpPidMapping.keys());
	const papers = (await Promise.all(dblpPids.map(pid => fetchPapers(pid, dblpPidMapping))));

	const uniquePapers = new Map<string, PublicationEntry>();

	papers.flat().forEach(paper => {
		const forceUpdatePaper = forcedDblpPids.size > 0 && paper.authors.some(author => author.pid && forcedDblpPids.has(author.pid));

		if (!forceUpdatePaper && paper.mdate.toMillis() < updatedAfter.toMillis()) {
			return;
		}

		if (!uniquePapers.has(paper.dblpKey)) {
			uniquePapers.set(paper.dblpKey, paper);
		}
	});

	return uniquePapers;
}

const updateDbPapers = async (papers: Map<string, PublicationEntry>) => {
	const updatePromises = Array.from(papers.values()).map(paper => {
		const docRef = doc(db, "publications", paper.dblpKey.replaceAll("/", "-")) as DocumentReference<PublicationEntry>;
		console.log(paper);
		return setDoc(docRef, paper, {merge: true});
	});

	await Promise.all(updatePromises);
}

const getMostRecentMdate = async () => {
	const publications = await getDocs(collection(db, "publications")) as QuerySnapshot<PublicationEntry>;
	const mdates = publications.docs.map(doc => doc.data().mdate);
	return mdates.reduce((a, b) => a > b ? a : b);
}

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
			isPostDoc: false,
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
			isPostDoc: arePostDocs,
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

	const professors = [];

	// Process professors from ulMatch[0] (active faculty)
	const activeLiMatches = ulMatch[0].match(/<li>(.*?)<\/li>/sgu);
	if (activeLiMatches) {
		for (const liMatch of activeLiMatches) {
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

				const professor: Omit<AdvisorEntry, "students" | "dblpPid" | "lastUpdate" | "collaborators"> = {
					name: professorName,
					url: nameMatch[1],
					title: title || "Professor",
					isEmeritus: false,
				};

				professors.push(professor);
			} else {
				const nameMatch = liMatch.match(/<b>(.*?)<\/b>/su);
				if (!nameMatch) {
					continue; // Skip if we can't parse the name
				}

				const professorName = cleanHtml(nameMatch[1]);
				title = liText.replace(professorName, "").trim();
				// Remove any leading commas and whitespace
				title = title.replace(/^,\s*/, "");
				// Only keep the first title (before any comma or additional roles)
				title = title.split(/,|\(/)[0].trim();

				const professor: Omit<AdvisorEntry, "students" | "dblpPid" | "lastUpdate" | "collaborators"> = {
					name: professorName,
					title: title || "Professor",
					isEmeritus: false,
				};

				professors.push(professor);
			}
		}
	}

	// Process professors from ulMatch[2] (emeritus faculty)
	if (ulMatch.length > 2) {
		const emeritusLiMatches = ulMatch[2].match(/<li>(.*?)<\/li>/sgu);
		if (emeritusLiMatches) {
			for (const liMatch of emeritusLiMatches) {
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

					const professor: Omit<AdvisorEntry, "students" | "dblpPid" | "lastUpdate" | "collaborators"> = {
						name: professorName,
						url: nameMatch[1],
						title: title || "Professor",
						isEmeritus: true,
					};

					professors.push(professor);
				} else {
					const nameMatch = liMatch.match(/<b>(.*?)<\/b>/su);
					if (!nameMatch) {
						continue; // Skip if we can't parse the name
					}

					const professorName = cleanHtml(nameMatch[1]);
					title = liText.replace(professorName, "").trim();
					// Remove any leading commas and whitespace
					title = title.replace(/^,\s*/, "");
					// Only keep the first title (before any comma or additional roles)
					title = title.split(/,|\(/)[0].trim();

					const professor: Omit<AdvisorEntry, "students" | "dblpPid" | "lastUpdate" | "collaborators"> = {
						name: professorName,
						title: title || "Professor",
						isEmeritus: true,
					};

					professors.push(professor);
				}
			}
		}
	}

	return professors;
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
	isEmeritus?: boolean;
	isPostDoc?: boolean;
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
		}

		shouldUpdate = Object.entries(updatedData).some(
			([key, value]) => key in data && data[key as keyof T] !== value
		);
	}

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
	const newDblpPids = [];

	for (const professor of professors) {
		const { updatedData } = await updateResearcher(professor, {
			collection: "advisors",
			getDocId: formatProfessorName,
			transformData: (prof: Partial<ExtendedResearcher> & { isEmeritus?: boolean }) => ({
				name: prof.name,
				...(prof.url ? { url: prof.url } : {}),
				...(prof.title ? { title: prof.title } : {}),
				...(typeof prof.isEmeritus === "boolean" ? { isEmeritus: prof.isEmeritus } : {}),
				students: [],
			}),
		});

		if (updatedData.dblpPid) {
			newDblpPids.push(updatedData.dblpPid);
		}
	}

	return newDblpPids;
}

const updateLabStudents = async () => {
	const students = await getLabStudents();
	const newDblpPids = [];

	for (const student of students) {
		const { docRef, updatedData, shouldUpdate } = await updateResearcher(student, {
			collection: "lab-members",
			getDocId: (name) => name,
			transformData: (stud: Partial<ExtendedResearcher>) => ({
				...(typeof stud.hasDoctorate === "boolean" ? { hasDoctorate: stud.hasDoctorate } : {}),
				...(typeof stud.isPostDoc === "boolean" ? { isPostDoc: stud.isPostDoc } : {}),
				...(stud.thesisTitle ? { thesisTitle: stud.thesisTitle } : {}),
				...(stud.year ? { year: stud.year } : {}),
				...(stud.url ? { url: stud.url } : {}),
			}),
		});

		if (updatedData.dblpPid) {
			newDblpPids.push(updatedData.dblpPid);
		}

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
						title: "Professor",
						isEmeritus: false // Default to non-emeritus for new professors
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

	return newDblpPids;
}

// for example: "Thomas A. Standish" should become "T. Standish"
const formatProfessorName = (name: string) => {
	const names = name.split(" ");
	return `${names[0][0]}. ${names[names.length - 1]}`;
}

// Helper function to create a map of researcher references to names
const createResearcherRefToNameMap = async (): Promise<Map<string, string>> => {
	const professorSnapshot = await getDocs(collection(db, "advisors")) as QuerySnapshot<AdvisorEntry>;
	const studentSnapshot = await getDocs(collection(db, "lab-members")) as QuerySnapshot<LabMemberEntry>;

	const researcherMap = new Map<string, string>();
	professorSnapshot.docs.forEach(doc => researcherMap.set(doc.ref.path, doc.data().name));
	studentSnapshot.docs.forEach(doc => researcherMap.set(doc.ref.path, doc.data().name));

	return researcherMap;
};

export const fetchAllResearchers = onRequest({
	timeoutSeconds: 540,
}, async (request, response) => {
	corsHandler(request, response, async () => {
		const professorSnapshot = await getDocs(collection(db, "advisors")) as QuerySnapshot<AdvisorEntry>;
		const studentSnapshot = await getDocs(collection(db, "lab-members")) as QuerySnapshot<LabMemberEntry>;

		const researcherMap = await createResearcherRefToNameMap();

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

export const fetchAllPublications = onRequest({
	timeoutSeconds: 540,
}, async (request, response) => {
	corsHandler(request, response, async () => {
		const publicationsSnapshot = await getDocs(collection(db, "publications")) as QuerySnapshot<PublicationEntry>;
		const researcherMap = await createResearcherRefToNameMap();

		const publications = publicationsSnapshot.docs.map(doc => {
			const publication = doc.data();

			// Convert researcher references to names
			if (publication.researchers && publication.researchers.length > 0) {
				const researchers = publication.researchers.map(ref =>
					researcherMap.get(ref.path)
				).filter(name => name !== undefined) as string[];

				return {
					...publication,
					researchers,
				};
			}

			return publication;
		});

		return response.json(publications);
	});
});

export const updateDatabase = onRequest({
	timeoutSeconds: 540,
}, async (request, response) => {
	corsHandler(request, response, async () => {
		try {
			const newDblpPids = await updateLabProfessors();
			newDblpPids.push(...await updateLabStudents());

			console.log("Updated researchers");

			const mostRecentMDate = await getMostRecentMdate();
			const onlyUpdateAfter = Timestamp.fromMillis(mostRecentMDate.toMillis() - MONTH);

			const papers = await fetchAllPapers(onlyUpdateAfter, new Set(newDblpPids));

			console.log("Fetched", papers.size, "relevant papers");

			await updateDbPapers(papers);

			response.send("Database updated");
		} catch (error) {
			logger.error("Error updating database", error);
			response.status(500).send("Error updating database");
		}
	});
});

export const updatePublicationsForResearcher = onRequest({
	timeoutSeconds: 540,
}, async (request, response) => {
	corsHandler(request, response, async () => {
		// given a researcher path, update their publications
		try {
			const researcherPath = request.body.researcherPath as string;

			// Convert the path string to a document reference
			const researcherRef = doc(db, researcherPath) as DocumentReference<ResearcherEntry>;
			const researcherDoc = await getDoc(researcherRef);

			if (!researcherDoc.exists()) {
				throw new Error("Researcher does not exist");
			}

			if (request.body.refresh) {
				console.log("Refreshing publications for", researcherDoc.data().name);
				// delete any existing publication with this researcher
				const publicationsSnapshot = await getDocs(collection(db, "publications")) as QuerySnapshot<PublicationEntry>;
				const publications = publicationsSnapshot.docs.map(doc => doc.data());

				for (const publication of publications) {
					if (!publication.researchers) {
						continue;
					}

					if (publication.researchers.some(ref => ref.path === researcherRef.path)) {
						console.log("Deleting publication", publication.dblpKey);
						await deleteDoc(doc(db, "publications", publication.dblpKey.replaceAll("/", "-")));
					}
				}
			}

			// check if researcher has a dblpPid
			if (!researcherDoc.data().dblpPid) {
				const dblpPid = await fetchDblpPid(researcherDoc.data().name);
				if (!dblpPid) {
					throw new Error("No DBLP PID found for researcher");
				}
				await updateDblpPidMapping(dblpPid, researcherRef);
			}

			const papers = await fetchPapers(researcherDoc.data().dblpPid, await fetchDblpPidMapping());

			const uniquePapers = new Map<string, PublicationEntry>(papers.map(paper => [paper.dblpKey, paper]));

			await updateDbPapers(uniquePapers);

			response.send("Publications updated");
		}
		catch (error) {
			logger.error("Error updating publications", error);
			response.status(500).send("Error updating publications");
		}
	});
});

