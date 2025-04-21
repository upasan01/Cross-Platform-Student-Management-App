import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';

const StudentDetails = () => {
  const { fullName } = useParams();
  const [student, setStudent] = useState(null);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchStudent = async () => {
      try {
        const response = await fetch('/student-details.json');
        const data = await response.json();

        const found = data.find(
          (s) =>
            s.studentDetails.fullName.toLowerCase() ===
            decodeURIComponent(fullName).toLowerCase()
        );

        if (found) {
          setStudent(found);
        } else {
          setError('Student not found');
        }
      } catch (err) {
        setError('Failed to fetch student details');
        console.error(err);
      }
    };

    fetchStudent();
  }, [fullName]);

  if (error) return <p className="text-red-500">{error}</p>;
  if (!student) return <p className="text-blue-500">Loading...</p>;

  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold mb-4">{student.studentDetails.fullName}</h1>
      <pre>{JSON.stringify(student.studentDetails, null, 2)}</pre>
    </div>
  );
};

export default StudentDetails;
