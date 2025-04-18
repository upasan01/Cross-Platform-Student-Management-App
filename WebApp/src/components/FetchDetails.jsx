import React from 'react';
import { NavLink } from 'react-router-dom';
import StudentDetails from './StudentDetails';
import ParentDetails from './ParentDetails';
import EducationalDetails from './EducationalDetails';
import ExtraDetails from './ExtraDetails';
import { fallback } from './DataDisplayKit';


const FetchDetails = ({ student }) => {
    if (!student) {
        console.log('No student data found');
        return null;
    }

    console.log('Student data from component:', student);

    return (
        <div className="max-w-5xl mx-auto bg-gray-50 p-6 space-y-6 rounded-2xl shadow-lg">
            <div className="flex align-baseline justify-center sm:space-x-8 sm:mb-6 sm:justify-start sm:ml-6">
                <img
                    src={student.imageUrl}
                    alt="Student"
                    className="avatar"
                />
                <div className="text-center sm:text-left px-4 py-20">
                    <h3 className="sm:text-4xl text-2xl font-bold text-gray-800">
                        {fallback(student.studentDetails.fullName)}
                    </h3>
                    <p className="text-gray-600">
                        {fallback(student.studentDetails.email)}
                    </p>
                </div>
            </div>

            <StudentDetails studentDetails={student.studentDetails} />
            <ParentDetails parentDetails={student.parentsDetails} />
            <EducationalDetails educationalDetails={student.educationalDetails} />
            <ExtraDetails extraDetails={student.extraDetails} />

            <div className="flex justify-center mt-6">
                <NavLink to={`/student/${encodeURIComponent(student.studentDetails.fullName)}`}>
                    <button className="blue-button flex items-center">
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            strokeWidth={1.5}
                            stroke="currentColor"
                            className="w-6 h-6"
                        >
                            <path
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5m8.25 3v6.75m0 0l-3-3m3 3l3-3M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125Z"
                            />
                        </svg>
                        <span className="ml-2">Click Here to Download Student Details</span>
                    </button>
                </NavLink>
            </div>
        </div>
    );
};

export default FetchDetails;
