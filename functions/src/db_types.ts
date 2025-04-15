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

export enum PublicationType {
	Article = "article",
	InProceedings = "inproceedings",
	Proceedings = "proceedings",
	Book = "book",
	InCollection = "incollection",
	PhdThesis = "phdthesis",
	// Add other types like MastersThesis if needed
	Unknown = "unknown",
}

/**
 * Represents author information stored within a PublicationEntry.
 * Contains raw data extracted from XML for later linking or display.
 */
export interface PublicationAuthorEntry {
	/** Raw name string from XML. */
	name: string;
	/** DBLP PID, if available. */
	pid?: string;
	/** ORCID, if available. */
	orcid?: string;
}

/**
 * Represents a publication entry suitable for storing in Firestore.
 */
export interface PublicationEntry {
	/** DBLP key (unique identifier). */
	dblpKey: string;
	/** Type of the publication. */
	type: PublicationType;
	/** Modification date from DBLP. */
	mdate: Timestamp; // Use Firestore Timestamp for dates
	/** Publication title. */
	title: string;
	/** Publication year as a number. */
	year: number;
	/** List of authors with their identifiers. */
	authors: PublicationAuthorEntry[];
	/** Optional electronic edition URLs. */
	ee?: string[];
	/** Optional DBLP URL. */
	url?: string;
	/** Optional journal name (for articles). */
	journal?: string;
	/** Optional volume identifier. */
	volume?: string;
	/** Optional issue number. */
	number?: string;
	/** Optional page numbers. */
	pages?: string;
	/** Optional book title (for conference/collection papers). */
	booktitle?: string;
	/** Optional cross-reference key. */
	crossref?: string;
	/** Optional publisher name. */
	publisher?: string;
	/** Optional ISBNs. */
	isbn?: string[];
	/** Optional series name. */
	series?: string;
	/** Optional school name (for thesis publications). */
	school?: string;
	 /** Optional publication type attribute (e.g., "informal"). */
	publtype?: string;
	 /** Optional stream name. */
	stream?: string;
	 /** Optional month. */
	month?: string;
	/** References to existing ResearcherEntry documents in Firestore.
	 * This would typically be populated *after* the initial conversion,
	 * by matching authors based on PID/name/ORCID.
	 */
	researchers?: DocumentReference<ResearcherEntry>[]; // Optional array of references
}

// --- Helper Function ---

/**
 * Helper to consistently handle fields that xml2js might return
 * as either a single object or an array when explicitArray is false.
 * @param field The field value from the parsed object.
 * @returns An array containing the element(s). Returns empty array if field is null/undefined.
 */
export function ensureArray<T>(field: T | T[] | undefined | null): T[] {
	if (field == null) { // Checks for undefined and null
		return [];
	}

	return Array.isArray(field) ? field : [field];
}


// --- Conversion Function ---

/**
 * Converts an R_ElementXml object (parsed from DBLP XML using xml2js
 * with explicitArray: false) into a Firestore-compatible PublicationEntry.
 *
 * @param rElement The R_ElementXml object representing a single <r> tag's content.
 * @returns A PublicationEntry object, or null if the input is invalid.
 */
export function convertR_ElementToPublicationEntry(rElement: R_ElementXml): PublicationEntry | null {
	let publicationType: PublicationType = PublicationType.Unknown;
	let pubData: PublicationBaseXml | null = null;

	// 1. Determine publication type and get the data object
	if (rElement.article) {
		publicationType = PublicationType.Article;
		pubData = rElement.article;
	} else if (rElement.inproceedings) {
		publicationType = PublicationType.InProceedings;
		pubData = rElement.inproceedings;
	} else if (rElement.proceedings) {
		publicationType = PublicationType.Proceedings;
		pubData = rElement.proceedings;
	} else if (rElement.book) {
		publicationType = PublicationType.Book;
		pubData = rElement.book;
	} else if (rElement.incollection) {
		publicationType = PublicationType.InCollection;
		pubData = rElement.incollection;
	} else if (rElement.phdthesis) {
		publicationType = PublicationType.PhdThesis;
		pubData = rElement.phdthesis;
	}
	// Add checks for other types if needed

	if (!pubData) {
		console.warn("Could not determine publication type or data for rElement:", rElement);
		return null;
	}

	// 2. Extract common data and perform conversions
	const key = pubData.$.key;
	const mdateStr = pubData.$.mdate;
	const yearStr = pubData.year;

	// Handle title which can be either a string or a TitleXml object
	let titleStr: string;
	if (typeof pubData.title === "string") {
		titleStr = pubData.title;
	} else if (pubData.title && typeof pubData.title === "object" && (pubData.title as TitleXml)._) {
		// If title is a TitleXml object, use the main text content
		titleStr = (pubData.title as TitleXml)._;
	} else {
		titleStr = "No Title"; // Default title if missing or invalid
	}

	let mdate: Timestamp;
	try {
		mdate = Timestamp.fromDate(new Date(mdateStr));
	} catch (e) {
		console.warn(`Invalid mdate format: ${mdateStr} for key ${key}. Using current time.`);
		mdate = Timestamp.now(); // Fallback
	}

	let year: number;
	if (yearStr && !isNaN(parseInt(yearStr, 10))) {
		year = parseInt(yearStr, 10);
	} else {
		console.warn(`Invalid year format: ${yearStr} for key ${key}. Using 0.`);
		year = 0; // Fallback
	}

	const mapToAuthor = (authorXml: AuthorXml): PublicationAuthorEntry => {
		const author: PublicationAuthorEntry = {
			name: authorXml._ ?? "Unknown Author",
		};

		if (authorXml.$.pid) {
			author.pid = authorXml.$.pid;
		}
		if (authorXml.$.orcid) {
			author.orcid = authorXml.$.orcid;
		}

		return author;
	}

	// 3. Extract Authors
	const authors: PublicationAuthorEntry[] = ensureArray(pubData.author).map(mapToAuthor);

	// 4. Extract Electronic Editions (EE)
	const eeUrls: string[] = ensureArray(pubData.ee).map(eeItem =>
		typeof eeItem === "string" ? eeItem : eeItem._
	);

	// 5. Extract type-specific and optional data
	const entry: Partial<PublicationEntry> = {
		dblpKey: key,
		type: publicationType,
		mdate: mdate,
		title: titleStr, // Use the extracted title string
		year: year,
		authors: authors,
		ee: eeUrls.length > 0 ? eeUrls : undefined,
		url: pubData.url,
		stream: pubData.stream,
		pages: pubData.pages,
		volume: pubData.volume,
		month: pubData.month,
		number: pubData.number,
		publtype: pubData.$.publtype,
	};

	if (!eeUrls.length) {
		delete entry.ee;
	}

	// Add fields specific to the detected type
	switch (publicationType) {
	case PublicationType.Article:
		entry.journal = (rElement.article as ArticleXml)?.journal;
		break;
	case PublicationType.InProceedings:
		entry.booktitle = (rElement.inproceedings as InProceedingsXml)?.booktitle;
		entry.crossref = (rElement.inproceedings as InProceedingsXml)?.crossref;
		break;
	case PublicationType.Proceedings:
		const procData = rElement.proceedings as ProceedingsXml;
		entry.publisher = procData?.publisher;
		entry.series = procData?.series?._; // Assuming series text is needed
		entry.isbn = ensureArray(procData?.isbn);
		// Note: DBLP often uses <author> for editors in <proceedings>
		// If <editor> tags exist, they would be handled here:
		// entry.editors = ensureArray(procData?.editor).map(...)
		break;
	case PublicationType.Book:
		const bookData = rElement.book as BookXml;
		entry.publisher = bookData?.publisher;
		entry.isbn = ensureArray(bookData?.isbn);
		break;
	case PublicationType.InCollection:
		entry.booktitle = (rElement.incollection as InCollectionXml)?.booktitle;
		entry.crossref = (rElement.incollection as InCollectionXml)?.crossref;
		break;
	case PublicationType.PhdThesis:
		entry.school = (rElement.phdthesis as PhdThesisXml)?.school;
		break;
	}

	 // Clean up undefined optional fields before casting
	Object.keys(entry).forEach(k => entry[k as keyof PublicationEntry] === undefined && delete entry[k as keyof PublicationEntry]);

	return entry as PublicationEntry;
}

// DBLP utilities
export interface DblpResponse {
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
export interface DblpXmlResponse {
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

/**
 * Represents the structure of an <author> tag as parsed by xml2js
 * with explicitArray: false. Can be single or array.
 */
interface AuthorXml {
	/** Text content (author name). */
	_: string;
	/** Attributes of the <author> tag ($). */
	$: {
	pid?: string; // DBLP Person ID attribute. Optional.
	orcid?: string; // ORCID identifier attribute. Optional.
	};
}

/**
 * Represents the structure of a <note> tag as parsed by xml2js
 * with explicitArray: false. Can be single or array.
 */
interface NoteXml {
	/** Text content of the note. */
	_: string;
	 /** Attributes of the <note> tag ($). */
	$: {
	type?: string; // Type attribute (e.g., "affiliation"). Optional.
	};
}

/**
 * Represents the structure of the <person> tag content as parsed by xml2js
 * with explicitArray: false.
 */
interface PersonInfoXml {
	/** Attributes of the <person> tag ($). */
	$: {
	key: string;
	mdate: string;
	};
	/** Author elements. Can be single or array. */
	author: AuthorXml | AuthorXml[];
	/** Note elements. Optional. Can be single or array. */
	note?: NoteXml | NoteXml[];
	/** URL strings. Optional. Can be single or array. */
	url?: string | string[];
}

/**
 * Represents the structure of an <na> tag within <coauthors>
 * with explicitArray: false. Can be single or array within <co>.
 */
interface CoAuthorNaXml {
	 /** Text content (coauthor name). */
	_: string;
	 /** Attributes of the <na> tag ($). */
	$: {
	pid: string; // DBLP Person ID attribute.
	f?: string; // 'f' attribute (full name?). Optional.
	};
}

/**
 * Represents the structure of a <co> tag within <coauthors>
 * with explicitArray: false. Can be single or array within <coauthors>.
 */
interface CoAuthorCoXml {
	 /** Attributes of the <co> tag ($). */
	$: {
	c: string; // Count attribute.
	};
	/** <na> elements. Can be single or array. */
	na: CoAuthorNaXml | CoAuthorNaXml[];
}

/**
 * Represents the structure of the <coauthors> tag as parsed by xml2js
 * with explicitArray: false.
 */
interface CoAuthorsInfoXml {
	 /** Attributes of the <coauthors> tag ($). */
	$: {
	n: string; // Total number of coauthors attribute.
	nc?: string; // Number of distinct coauthors attribute. Optional.
	};
	/** <co> elements. Can be single or array. */
	co: CoAuthorCoXml | CoAuthorCoXml[];
}


/**
 * Represents the structure of an <ee> tag as parsed by xml2js
 * with explicitArray: false. Can be single or array.
 */
interface ElectronicEditionXml {
	/** Text content (the URL). */
	_: string;
	/** Attributes of the <ee> tag ($). */
	$: {
	type?: string; // Type attribute (e.g., "oa"). Optional.
	};
}

/**
 * Represents the structure of a <series> tag as parsed by xml2js
 * with explicitArray: false. Typically single.
 */
interface SeriesXml {
	 /** Text content (series name). */
	_: string;
	 /** Attributes of the <series> tag ($). */
	$: {
	 href: string; // href attribute.
	};
}

/**
 * Represents the structure of a <title> tag as parsed by xml2js
 * with explicitArray: false when it contains formatting.
 */
interface TitleXml {
	/** Main text content of the title. */
	_: string;
	/** Optional formatting or other metadata. */
	i?: string;
	/** Any other properties that might be present. */
	[key: string]: string | number | boolean | undefined;
}

/**
 * Base structure for publication data common fields as parsed by xml2js
 * with explicitArray: false.
 */
interface PublicationBaseXml {
	/** Attributes common to all publication types within <r> ($). */
	$: {
	key: string;
	mdate: string;
	publtype?: string; // Publication type attribute. Optional.
	};
	/** Title can be either a string or a TitleXml object with formatting information. */
	title?: string | TitleXml;
	/** Year string. Optional. */
	year?: string;
	 /** Author elements. Optional. Can be single or array. */
	author?: AuthorXml | AuthorXml[];
	/** Electronic edition elements. Optional. Can be single or array. */
	ee?: (ElectronicEditionXml | string) | (ElectronicEditionXml | string)[];
	/** DBLP URL string. Optional. */
	url?: string;
	 /** Stream string. Optional. */
	stream?: string;
	/** Pages string. Optional. */
	pages?: string;
	/** Volume string. Optional. */
	volume?: string;
	/** Month string. Optional. */
	month?: string;
	/** Number string. Optional. */
	number?: string;
}

/**
 * Represents an Article publication structure as parsed by xml2js
 * with explicitArray: false.
 */
interface ArticleXml extends PublicationBaseXml {
	/** Journal name string. Optional. */
	journal?: string;
}

/**
 * Represents an InProceedings publication structure as parsed by xml2js
 * with explicitArray: false.
 */
interface InProceedingsXml extends PublicationBaseXml {
	/** Booktitle string. Optional. */
	booktitle?: string;
	/** Crossref key string. Optional. */
	crossref?: string;
}

/**
 * Represents a Proceedings publication structure as parsed by xml2js
 * with explicitArray: false.
 */
interface ProceedingsXml extends PublicationBaseXml {
	/** Publisher string. Optional. */
	publisher?: string;
	/** Series element. Optional. */
	series?: SeriesXml;
	/** ISBN strings. Optional. Can be single or array. */
	isbn?: string | string[];
	/** Editor elements. Optional. Can be single or array. */
	editor?: AuthorXml | AuthorXml[];
}

/**
 * Represents a Book publication structure as parsed by xml2js
 * with explicitArray: false.
 */
interface BookXml extends PublicationBaseXml {
	 /** Publisher string. Optional. */
	publisher?: string;
	/** ISBN strings. Optional. Can be single or array. */
	isbn?: string | string[];
}

/**
 * Represents an InCollection publication structure as parsed by xml2js
 * with explicitArray: false.
 */
interface InCollectionXml extends PublicationBaseXml {
	/** Booktitle string. Optional. */
	booktitle?: string;
	/** Crossref key string. Optional. */
	crossref?: string;
}

/**
 * Represents a PhD Thesis publication structure as parsed by xml2js
 * with explicitArray: false.
 */
interface PhdThesisXml extends PublicationBaseXml {
	/** School name string. Optional. */
	school?: string;
}

/**
 * Represents a single element within the <r> array as parsed by xml2js
 * with explicitArray: false. The key will be the publication type.
 * The value will be the publication object itself (not an array).
 */
interface R_ElementXml {
	article?: ArticleXml;
	inproceedings?: InProceedingsXml;
	proceedings?: ProceedingsXml;
	book?: BookXml;
	incollection?: InCollectionXml;
	phdthesis?: PhdThesisXml;
	// Add other potential publication types here if needed
}

/**
 * Represents the overall structure of the DBLP person XML file
 * as parsed by xml2js with explicitArray: false.
 */
export interface DblpPersonXml {
	/** Root element containing all person data. */
	dblpperson: {
	/** Attributes of the <dblpperson> tag ($). */
	$: {
		name: string;
		pid: string;
		n: string; // Number attribute as string
	};
	/** <person> info object. Optional. */
	person?: PersonInfoXml;
	/**
	 * Publication elements (<r> tags). Optional. Can be single or array.
	 * Each element will have a key corresponding to the publication type.
	 */
	r?: R_ElementXml | R_ElementXml[];
	/** <coauthors> info object. Optional. */
	coauthors?: CoAuthorsInfoXml;
	};
}
