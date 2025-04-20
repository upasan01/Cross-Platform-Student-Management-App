import React from 'react';
import StudentDetails from './StudentDetails';
import ParentDetails from './ParentDetails';
import EducationalDetails from './EducationalDetails';
import ExtraDetails from './ExtraDetails';
import DownloadButton from './DownloadButton';


const FetchDetails = ({ student }) => {
    if (!student) {
        return null;
    }

    return (
        <div>

            <StudentDetails studentDetails={student.studentDetails} />
            <ParentDetails parentDetails={student.parentsDetails} />
            <EducationalDetails educationalDetails={student.educationalDetails} />
            <ExtraDetails extraDetails={student.extraDetails} />

            <div className="flex justify-center mt-6">
               < DownloadButton studentId={student._id} />
            </div>
        </div>
    );
};

export default FetchDetails;
