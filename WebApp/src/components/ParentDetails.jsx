import React from 'react';
import { InfoGrid, InfoItem, Section, fallback } from './DataDisplayKit';


const ParentDetails = ({ parentDetails }) => {
    return (
        <Section title="Parent Details">
            <InfoGrid>
                <InfoItem
                    label="Father"
                    value={`${fallback(parentDetails?.father?.fullName)}`}
                />
                <InfoItem label="Occupation (Father)" value={fallback(parentDetails?.father?.occupation)} />
                <InfoItem
                    label="Mother"
                    value={`${fallback(parentDetails?.mother?.fullName)}`}
                />
                <InfoItem label="Occupation (Mother)" value={fallback(parentDetails?.mother?.occupation)} />
                <InfoItem label="Phone (Father)" value={fallback(parentDetails?.father?.phone)} />
                <InfoItem label="Phone (Mother)" value={fallback(parentDetails?.mother?.phone)} />
                <InfoItem label="Income (Father)" value={fallback(parentDetails?.father?.income)} />
                <InfoItem label="Income (Mother)" value={fallback(parentDetails?.mother?.income)} />
                <InfoItem label="Aadhaar Number (Father)" value={fallback(parentDetails?.father?.aadhaarNumber)} />
                <InfoItem label="Aadhaar Number (Mother)" value={fallback(parentDetails?.mother?.aadhaarNumber)} />
                <InfoItem label="PAN Number (Father)" value={fallback(parentDetails?.father?.panNumber)} />
                <InfoItem label="PAN Number (Mother)" value={fallback(parentDetails?.mother?.panNumber)} />
                <InfoItem
                    label="Local Guardian"
                    value={`${fallback(parentDetails?.localGuardian?.fullName)}`}
                />
                <InfoItem label="Occupation (Guardian)" value={fallback(parentDetails?.localGuardian?.occupation)} />
                <InfoItem
                    label="Address (Guardian)"
                    value={`${fallback(parentDetails?.localGuardian?.address?.fullAddress)}`}
                />
            </InfoGrid>
        </Section>
    );
};

export default ParentDetails;
