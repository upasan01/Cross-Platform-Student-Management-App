import React from 'react';
import { InfoGrid, InfoItem, Section, fallback } from './DataDisplayKit';


const ParentDetails = ({ parentDetails }) => {
    return (
        <Section title="Parent Details">
            <InfoGrid>
                <InfoItem
                    label="Father"
                    value={`${fallback(parentDetails?.father?.fullName)} (${fallback(parentDetails?.father?.occupation)})`}
                />
                <InfoItem label="Phone (Father)" value={fallback(parentDetails?.father?.phone)} />
                <InfoItem
                    label="Mother"
                    value={`${fallback(parentDetails?.mother?.fullName)} (${fallback(parentDetails?.mother?.occupation)})`}
                />
                <InfoItem label="Phone (Mother)" value={fallback(parentDetails?.mother?.phone)} />
                <InfoItem label="Income (Father)" value={fallback(parentDetails?.father?.income)} />
                <InfoItem label="Income (Mother)" value={fallback(parentDetails?.mother?.income)} />
            </InfoGrid>

            <div className="mt-4">
                <InfoItem
                    label="Local Guardian"
                    value={`${fallback(parentDetails?.localGuardian?.fullName)} (${fallback(parentDetails?.localGuardian?.occupation)})`}
                />
                <InfoItem
                    label="Address"
                    value={`${fallback(parentDetails?.localGuardian?.address?.fullAddress)}, ${fallback(parentDetails?.localGuardian?.address?.city)}`}
                />
            </div>
        </Section>
    );
};

export default ParentDetails;
