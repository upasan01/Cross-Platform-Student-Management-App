import React from 'react';
import { InfoGrid, InfoItem, Section, fallback } from './DataDisplayKit';

const EducationalDetails = ({ educationalDetails }) => {
    return (
        <Section title="Educational Details">
            <InfoGrid>
                <InfoItem
                    label="HS"
                    value={`${fallback(educationalDetails?.hs?.percentage)}% - ${fallback(
                        educationalDetails?.hs?.school
                    )} (${fallback(educationalDetails?.hs?.year)})`}
                />
                <InfoItem
                    label="Secondary"
                    value={`${fallback(educationalDetails?.secondary?.percentage)}% - ${fallback(
                        educationalDetails?.secondary?.school
                    )} (${fallback(educationalDetails?.secondary?.year)})`}
                />
                <InfoItem
                    label="Diploma"
                    value={`CGPA ${fallback(educationalDetails?.diploma?.cgpa)} - ${fallback(
                        educationalDetails?.diploma?.college
                    )} (${fallback(educationalDetails?.diploma?.year)})`}
                />
            </InfoGrid>
        </Section>
    );
};

export default EducationalDetails;
