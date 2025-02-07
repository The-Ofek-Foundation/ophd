import { DocumentReference, FieldValue, Timestamp } from "firebase/firestore";

export type ResearcherEntry = {
	name: string;
	url?: string;
	lastUpdate: Timestamp | FieldValue;
	dblpPid: string;
	collaborators: DocumentReference<ResearcherEntry>[];
}

export type LabMemberEntry = ResearcherEntry & {
	advisors: DocumentReference<AdvisorEntry>[];
	hasDoctorate: boolean;
	year?: number;
	thesisTitle?: string;
}

export type GraduatedLabMemberEntry = LabMemberEntry & {
	year: number;
	thesisTitle: string;
}

export type AdvisorEntry = ResearcherEntry & {
	students: DocumentReference<LabMemberEntry>[];
	title: string;
}

export type DblpPid = {
	pid: string;
	researcher: DocumentReference<ResearcherEntry>;
}
