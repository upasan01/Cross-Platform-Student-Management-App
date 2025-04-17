import React from 'react';
import { NavLink } from 'react-router-dom';
import StudentDetails from './StudentDetails';
import ParentDetails from './ParentDetails';
import EducationalDetails from './EducationalDetails';
import ExtraDetails from './ExtraDetails';
import { fallback } from './DataDisplayKit';

const FetchDetails = ({ student }) => {
    if (!student)
        return (console.log('No student data found'), null);

    console.log('Student data from component:', student);

    return (
        <div className="max-w-5xl mx-auto bg-gray-50 p-6 space-y-6 rounded-2xl shadow-lg">
    
            <div className='flex align-baseline justify-center sm:justify-start space-x-4 mb-6'>
                <img
                    src={student.imageUrl}
                    alt="Student Image" className='avatar'
                />
                <div className="text-center sm:text-left px-4 py-20">
                    <h3 className="text-4xl font-bold text-gray-800">{fallback(student.studentDetails.fullName)}</h3>
                    <p className="text-gray-600">{fallback(student.studentDetails.email)}</p>
                </div>
            </div>

            <StudentDetails studentDetails={student.studentDetails} />


            <ParentDetails parentDetails={student.parentsDetails} />

           
            <EducationalDetails educationalDetails={student.educationalDetails} />

   
            <ExtraDetails extraDetails={student.extraDetails} />


            <div className="text-center">
                <NavLink to={`/student/${encodeURIComponent(student.studentDetails.fullName)}`}>
                    <button className="mt-4 bg-blue-600 text-white font-medium px-6 py-2 rounded-xl hover:bg-blue-700 transition-all">
                        Click Here to Download Student Details
                    </button>
                </NavLink>
            </div>
        </div>
    );
};

export default FetchDetails;
