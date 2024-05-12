import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

// eslint-disable-next-line @typescript-eslint/no-var-requires
const he = require("he");
// eslint-disable-next-line @typescript-eslint/no-var-requires
const xml2js = require("xml2js");
import cors from "cors";
const corsHandler = cors({origin: true});
import { db } from "./initialize_app";
import { DocumentReference, QuerySnapshot, Timestamp, collection, doc, getDoc, getDocs, serverTimestamp, setDoc } from "firebase/firestore";
import { AdvisorEntry, DblpPid, GraduatedLabMemberEntry, LabMemberEntry, ResearcherEntry } from "./db_types";

const DOCTORATE_STUDENTS_URL = "https://ics.uci.edu/~theory/doctorates.html";
const THEORY_URL = "https://ics.uci.edu/~theory/";

const DBLP_AUTHOR_LOOKUP_URL = "https://dblp.org/search/author/api?h=1&format=json&c=1&q=";
const DBLP_AUTHOR_URL = "https://dblp.org/pid/";


const cleanHtml = (html: string) =>
	(he.decode(html) as string).replace(/<[^>]*>?/gm, "").replace(/\s+/g, " ").trim();

const getNameAndUrl = (html: string) => {
	const nameMatch = (he.decode(html) as string).match(/<a href="(.*?)">(.*?)<\/a>/u);
	return {
		name: nameMatch ? cleanHtml(nameMatch[2]) : cleanHtml(html),
		url: nameMatch ? nameMatch[1] : undefined,
	};
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
		}
		previousYear = student.year;
		students.push(student);
	}

	return students;
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

	const ulContent = ulMatch[1] + ulMatch[3];

	const students = [];
	const liMatches = ulContent.match(/<li>(.*?)<\/li>/sgu);

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
			hasDoctorate: false,
		};

		students.push(student);
	}

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
		if (!nameMatch) {
			const nameMatch = liMatch.match(/<b>(.*?)<\/b>/su);
			if (!nameMatch) {
				throw new Error("Failed to parse name match");
			}

			const professor: Omit<AdvisorEntry, "students" | "dblpPid" | "lastUpdate" | "collaborators"> = {
				name: cleanHtml(nameMatch[1]),
			};

			professors.push(professor);
		} else {
			const professor: Omit<AdvisorEntry, "students" | "dblpPid" | "lastUpdate" | "collaborators"> = {
				name: cleanHtml(nameMatch[2]),
				url: nameMatch[1],
			};

			professors.push(professor);
		}
	}

	return professors;
}

const fetchDblpPid = async (name: string) => {
	logger.info("Fetching DBLP PID for", name);
	
	const response = await fetch(DBLP_AUTHOR_LOOKUP_URL + name)
		.then(response => response.json())
		.catch(error => console.error("Failed to fetch data:", error, name));
	
	logger.debug(response);

	if (response?.result && response.result.hits.hit?.length > 0) {
		const pid = response.result.hits.hit[0].info.url as string;
		return pid.split("pid/")[1];
	} else {
		logger.error("Failed to fetch DBLP PID for", name);
		return "";
	}
}

const fetchCollaborators = async (dblpPid: string) => {
	const authorXmlUrl = DBLP_AUTHOR_URL + dblpPid + ".xml";

	try {
		const response = await fetch(authorXmlUrl);
		const responseText = await response.text();
        
		if (!responseText) {
			throw new Error("Failed to fetch data: " + dblpPid);
		}

		const parser = new xml2js.Parser();
		// eslint-disable-next-line @typescript-eslint/no-explicit-any
		const parsed: any = await new Promise((resolve, reject) => {
			// eslint-disable-next-line @typescript-eslint/no-explicit-any
			parser.parseString(responseText, (err: Error, result: any) => {
				if (err) {
					console.error("Failed to parse XML:", err, dblpPid);
					reject(err);
				} else {
					resolve(result);
				}
			});
		});

		const coauthors = parsed.dblpperson.coauthors;

		// eslint-disable-next-line @typescript-eslint/no-explicit-any
		return coauthors && coauthors.length > 0 ? coauthors[0].co.map((entry: any) => entry.na[0]["$"].pid) : [];
	} catch (error) {
		console.error("An error occurred:", error, dblpPid);
		throw error;
	}
};

const fetchNewCollaborators = async (dblpPid: string, docRef: DocumentReference<ResearcherEntry>, existingCollaborators: DocumentReference<ResearcherEntry>[]) => {
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

const updateLabStudents = async () => {
	const students = await getLabStudents();
	
	for (const student of students) {
		logger.info("Checking student", student.name);
		const docRef = doc(db, "lab-members", student.name) as DocumentReference<LabMemberEntry>;
		const docSnap = await getDoc(docRef);

		const updatedData: Partial<LabMemberEntry> = {
			hasDoctorate: student.hasDoctorate,
		};

		if (student.thesisTitle) updatedData.thesisTitle = student.thesisTitle;
		if (student.year) updatedData.year = student.year;
		if (student.url) updatedData.url = student.url;

		if ("advisors" in student && (student.advisors as string[]).length > 0) {
			updatedData.advisors = [];
			for (const advisor of (student.advisors as string[])) {
				const advisorRef = doc(db, "advisors", advisor) as DocumentReference<AdvisorEntry>;
				updatedData.advisors.push(advisorRef);
			}
		}

		let shouldUpdateMember = false;
		let shouldUpdateAdvisors = false;
		
		if (!docSnap.exists()) {
			updatedData.name = student.name;
			updatedData.dblpPid = await fetchDblpPid(student.name);
			updatedData.collaborators = [];

			shouldUpdateMember = true;
			shouldUpdateAdvisors = true;
		} else {
			const data = docSnap.data();

			if (data.year === updatedData.year &&
				data.url === updatedData.url &&
				(data.advisors || []).length === (updatedData.advisors || []).length &&
				data.hasDoctorate === updatedData.hasDoctorate &&
				data.thesisTitle === updatedData.thesisTitle) {
			} else {
				shouldUpdateMember = true;
				shouldUpdateAdvisors = data.advisors !== updatedData.advisors;
			}
		}

		const updatedRecently = docSnap.exists() && (docSnap.data().lastUpdate as Timestamp).toDate() > new Date(Date.now() - 1000 * 60 * 60 * 24 * 30 * 6);
		const dblpPid = docSnap.exists() ? docSnap.data().dblpPid : updatedData.dblpPid;

		if (dblpPid && (!docSnap.exists() || (!updatedRecently && Math.random() < 0.2))) {
			const existingCollaborators = docSnap.exists() ? docSnap.data().collaborators || [] : [];
			const newCollaborators = await fetchNewCollaborators(dblpPid, docRef, existingCollaborators);

			if (newCollaborators.length > 0) {
				logger.log("Adding collaborators", newCollaborators.map(collaborator => collaborator.id));
				updatedData.collaborators = [...existingCollaborators, ...newCollaborators];
				shouldUpdateMember = true;
			}
		}

		if (shouldUpdateMember) {
			updatedData.lastUpdate = serverTimestamp();
			await setDoc(docRef, updatedData, {merge: true});
		}

		if (updatedData.dblpPid) {
			const dblpPidRef = doc(db, "dblp-pids", updatedData.dblpPid.replace("/", "-")) as DocumentReference<DblpPid>;
			await setDoc(dblpPidRef, {pid: updatedData.dblpPid, researcher: docRef}, {merge: true});
		}

		if (shouldUpdateAdvisors && "advisors" in student) {
			for (const advisor of (student.advisors as string[])) {
				const advisorRef = doc(db, "advisors", advisor) as DocumentReference<AdvisorEntry>;
				const advisorDoc = await getDoc(advisorRef);
				if (!advisorDoc.exists()) {
					const advisorDblpPid = await fetchDblpPid(advisor);
					await setDoc(advisorRef, {name: advisor, lastUpdate: serverTimestamp(), students: [docRef], dblpPid: advisorDblpPid, collaborators: []} as AdvisorEntry);

					const dblpPidRef = doc(db, "dblp-pids", advisorDblpPid.replace("/", "-")) as DocumentReference<DblpPid>;
					await setDoc(dblpPidRef, {pid: advisorDblpPid, researcher: advisorRef}, {merge: true});
				} else if (!rcontains(advisorDoc.data().students, docRef)) {
					await setDoc(advisorRef, {students: [...advisorDoc.data().students, docRef]}, {merge: true});
				}
			}
		}
	}
}

// name should be first initial of name and middle name/s, a period after each, a space, then last name
// for example: "Thomas A. Standish" should become "T. A. Standish"
const formatProfessorName = (name: string) => {
	const names = name.split(" ");
	return names.slice(0, -1).map(n => n[0].replace(".", "") + ".").join(" ") + " " + names[names.length - 1];
}

const updateLabProfessors = async () => {
	const professors = await getProfessors();

	for (const professor of professors) {
		logger.info("Checking professor", professor.name);
		const docRef = doc(db, "advisors", formatProfessorName(professor.name)) as DocumentReference<AdvisorEntry>;
		const docSnap = await getDoc(docRef);

		const updatedData: Partial<AdvisorEntry> = {
			name: professor.name,
		};

		if (professor.url) updatedData.url = professor.url;

		let shouldUpdateAdvisor = false;

		if (!docSnap.exists()) {
			updatedData.dblpPid = await fetchDblpPid(professor.name);
			updatedData.students = [];
			updatedData.collaborators = [];

			shouldUpdateAdvisor = true;
		} else {
			shouldUpdateAdvisor = docSnap.data().url !== updatedData.url || docSnap.data().name !== updatedData.name;
		}

		const updatedRecently = docSnap.exists() && (docSnap.data().lastUpdate as Timestamp).toDate() > new Date(Date.now() - 1000 * 60 * 60 * 24 * 30 * 6);
		const dblpPid = docSnap.exists() ? docSnap.data().dblpPid : updatedData.dblpPid;

		if (dblpPid && (!docSnap.exists() || (!updatedRecently && Math.random() < 0.1))) {
			const existingCollaborators = docSnap.exists() ? docSnap.data().collaborators || [] : [];
			const newCollaborators = await fetchNewCollaborators(dblpPid, docRef, existingCollaborators);

			if (newCollaborators.length > 0) {
				logger.log("Adding collaborators", newCollaborators.map(collaborator => collaborator.id));
				updatedData.collaborators = [...existingCollaborators, ...newCollaborators];
				shouldUpdateAdvisor = true;
			}
		}

		if (shouldUpdateAdvisor) {
			updatedData.lastUpdate = serverTimestamp();
			await setDoc(docRef, updatedData, {merge: true});
		}

		if (updatedData.dblpPid) {
			const dblpPidRef = doc(db, "dblp-pids", updatedData.dblpPid.replace("/", "-")) as DocumentReference<DblpPid>;
			await setDoc(dblpPidRef, {pid: updatedData.dblpPid, researcher: docRef}, {merge: true});
		}
	}
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

		return response.json(
			{
				professors,
				students,
			}
		);
	});
});


export const updateDatabase = onRequest(async (request, response) => {
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
