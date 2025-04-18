import React, { useState } from 'react';
import axios from 'axios';
import Search from '../components/Search';
import FetchDetails from '../components/FetchDetails';
import Spinner from '../components/Spinner';

const Dashboard = () => {
  const [student, setStudent] = useState(null);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSearch = async (searchQuery) => {
    setLoading(true);
    setError('');
    setStudent(null);
    console.log('Cooking:', searchQuery);

    try {
      const token = localStorage.getItem('adminToken');

      const response = await axios.get(`http://localhost:3000/v1/api/admin/search`, {
        params: { searchQuery },
        headers: {
          token: token
        }
      });
      console.log('Response:', response.data);

      const data = response.data;

      if (!data.results || data.results.length === 0) {
        setError('Student not found');
      } else {
        setStudent(data);
        console.log('Student data:', data);
      }
    } catch (err) {
      console.error('Caught an error:', err);
      setError(err.response?.data?.message || 'Error fetching data');
    } finally {
      setLoading(false);
    }
  };


  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-100 to-blue-100 flex flex-col items-center justify-start p-4 sm:p-6 md:p-8 lg:p-10 xl:p-12">
      <div className="bg-white/80 backdrop-blur-lg shadow-xl rounded-2xl w-full max-w-4xl sm:max-w-5xl lg:max-w-6xl p-8 sm:p-10 mb-6 sm:mb-8">
        <div className="text-2xl sm:text-3xl font-bold font-sans text-blue-800 mb-4 px-2 ml-4 inline-block max-w-fit typewriter">
          Welcome, Admin
        </div>
        <p className="text-gray-700 leading-relaxed text-sm sm:text-base">
          This is your student management dashboard. Use the search box below to find students by their Email or Name. This is the admin panel.
        </p>
      </div>

      <Search onSearch={handleSearch} />

      {loading && (
        <div className="flex items-center justify-center h-64 w-full">
          <Spinner />
        </div>
      )}

      {!loading && (
        <div className="w-full max-w-4xl sm:max-w-5xl lg:max-w-6xl mt-6">
          {error && (
            <div className="text-center text-red-600 font-medium bg-red-100 px-4 py-3 rounded-lg shadow-sm animate-fade-in">
              {error}
            </div>
          )}

          {student && (
            <div className="animate-fade-in">
              <FetchDetails student={student} />
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default Dashboard;
