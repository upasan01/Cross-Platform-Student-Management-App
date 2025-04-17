import React, { useState } from 'react';
import Search from '../components/Search';
import FetchDetails from '../components/FetchDetails';
import Spinner from '../components/Spinner';


const Dashboard = () => {
  const [student, setStudent] = useState(null);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSearch = async (query, category) => {
    setLoading(true);
    setError('');
    setStudent(null);
  
    try {
      const response = await fetch(`http://localhost:5000/api/students/search?query=${encodeURIComponent(query)}&category=${encodeURIComponent(category)}`);
      if (!response.ok) {
        const { error } = await response.json();
        throw new Error(error || 'Something went wrong');
      }
      const data = await response.json();
  
      if (data && Object.keys(data).length === 0) {
        setError('Student not found');
      } else {
        setStudent(data);
      }
    }  catch (err) {
      console.error('Caught an error:', err);
      setError(err.message || 'Error fetching data');
    } finally {
      setLoading(false);
    }
  };
  
  

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-100 to-blue-100 flex flex-col items-center justify-start p-8">
      <div className="bg-white/80 backdrop-blur-lg shadow-xl rounded-2xl w-full max-w-5xl p-10 mb-8">
        <h2 className="text-3xl font-bold font-sans text-blue-800 mb-4">Welcome, User 👋</h2>
        <p className="text-gray-700 leading-relaxed text-sm sm:text-base">
          This is your student management dashboard. Use the search box below to find students by their Email, Roll Number, Registration Number, or Name. This is the admin panel.
        </p>
      </div>

      <Search onSearch={handleSearch} />

      {loading && (
        <div className="flex items-center justify-center h-64 w-full">
          <Spinner />
        </div>
      )}

      {!loading && (
        <div className="w-full max-w-5xl mt-6">
          {error && (
            <div className="text-center text-red-600 font-medium bg-red-100 px-4 py-3 rounded-lg shadow-sm animate-fade-in">
              {error}
            </div>
          )}

          {student && (
            <div className="animate-fade-in">
              <FetchDetails student={student[0]} />
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default Dashboard;
