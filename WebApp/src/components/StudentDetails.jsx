import React from 'react';
import { InfoGrid, InfoItem, Section, formatDate, fallback, addressToString} from './DataDisplayKit';

const StudentDetails = ({ studentDetails }) => {
    
    return (
        <>
            <Section title="Student Details" className="card-details">
                <InfoGrid>
                    <InfoItem label="Roll" value={fallback(studentDetails.uniRollNumber)} />
                    <InfoItem label="Reg No" value={fallback(studentDetails.regNumber)} />
                    <InfoItem label="Session" value={fallback(studentDetails.session)} />
                    <InfoItem label="Phone" value={fallback(studentDetails.phoneNumber)} />
                    <InfoItem label="Email" value={fallback(studentDetails.email)} />
                    <InfoItem label="Aadhaar Number" value={fallback(studentDetails?.aadhaarNumber)} />
                    <InfoItem label="PAN Number" value={fallback(studentDetails?.panNumber)} />
                    <InfoItem label="DOB" value={formatDate(studentDetails.dob)} />
                    <InfoItem label="Gender" value={fallback(studentDetails.gender)} />
                    <InfoItem label="Blood Group" value={fallback(studentDetails.bloodGroup)} />
                    <InfoItem label="Religion" value={fallback(studentDetails.religion)} />
                    <InfoItem label="Category" value={fallback(studentDetails.category)} />
                    <InfoItem label="Mother Tongue" value={fallback(studentDetails.motherTounge)} />
                    <InfoItem label="Height" value={`${fallback(studentDetails.height)} `} />
                    <InfoItem label="Weight" value={`${fallback(studentDetails.weight)} `} />
                </InfoGrid>
            </Section>
            <Section title="Address" className="card-details">
                <div className="space-y-2">
                    <InfoItem label="Permanent" value={addressToString(studentDetails.permanentAddress)} />
                    <InfoItem label="Residential" value={addressToString(studentDetails.residentialAddress)} />
                </div>
            </Section>
        </>
    );
};

export default StudentDetails;
