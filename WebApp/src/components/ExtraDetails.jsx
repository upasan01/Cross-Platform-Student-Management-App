import React from 'react';
import { InfoGrid, InfoItem, Section, fallback } from './DataDisplayKit';

const ExtraDetails = ({ extraDetails }) => {
    return (
        <Section title="Extra Details">
            <InfoGrid>
                <InfoItem label="Hobbies" value={fallback(extraDetails?.hobbies)} />
                <InfoItem label="Interested Domain" value={fallback(extraDetails?.interestedDomain)} />
                <InfoItem label="Best Subject" value={fallback(extraDetails?.bestSubject)} />
                <InfoItem label="Least Subject" value={fallback(extraDetails?.leastSubject)} />
            </InfoGrid>
        </Section>
    );
};

export default ExtraDetails;
