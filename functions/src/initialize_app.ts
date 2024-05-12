// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
	apiKey: "AIzaSyDzJIJIGknWTPVo_-ZiyGRlIr2tKIQrchk",
	authDomain: "ophd-53b5e.firebaseapp.com",
	projectId: "ophd-53b5e",
	storageBucket: "ophd-53b5e.appspot.com",
	messagingSenderId: "1010354726289",
	appId: "1:1010354726289:web:05a5a6286d269dbbc96630",
	measurementId: "G-D1TC9ZKGG6"
};

export const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);