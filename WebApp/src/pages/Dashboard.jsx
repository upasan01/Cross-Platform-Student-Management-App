import React, { useState, useEffect } from 'react';
import axios from 'axios';
import Search from '../components/Search';
import Spinner from '../components/Spinner';
import Navbar from '../components/Navbar';
import StudentCardList from '../components/StudentCardList';
import { LogOut, ArrowUp } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import DownloadExcelButton from '../components/DownloadExcelButton';
import StudentChunk from '../components/StudentListChunk';

const Dashboard = () => {
  const [student, setStudent] = useState(null);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [isSearchActive, setIsSearchActive] = useState(false);
  const [showArrow, setShowArrow] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setShowArrow(window.scrollY > 300);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const navigate = useNavigate();

  const handleLogout = () => {
    sessionStorage.removeItem('adminToken');
    localStorage.removeItem('adminToken');
    alert('You have been logged out.');
    navigate('/');
  };

  const handleSearch = async (searchQuery) => {
    setLoading(true);
    setError('');
    setStudent(null);
    setIsSearchActive(true);

    try {
      const token = sessionStorage.getItem('adminToken');
      const response = await axios.get(`${import.meta.env.VITE_BASE_URL}/api/v1/admin/search`, {
        params: { searchQuery },
        headers: { token },
      });

      const data = response.data;

      if (!data.results || data.results.length === 0) {
        setError('Student not found');
      } else {
        setStudent(data.results);
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
      <Navbar />

      <div className="bg-white/80 backdrop-blur-lg shadow-xl rounded-2xl w-full max-w-4xl sm:max-w-5xl lg:max-w-6xl p-8 mb-6 mt-20">
        <div className="text-2xl sm:text-3xl font-bold font-sans text-blue-800 mb-4 px-2 ml-4 max-w-fit typewriter">
          Welcome, Admin
        </div>
        <p className="text-gray-700 text-sm sm:text-base">
          Use the search box below to find students by their Email or Name. You save those data in your local storage for later use.
        </p>
        <div className="flex flex-col items-center justify-center mt-4 text-sm sm:text-base text-gray-700 space-y-2">
          <p>OR</p>
          <p>
            Download All Students Data <DownloadExcelButton />
          </p>
        </div>
      </div>

      <Search onSearch={handleSearch} />

      {loading ? (
        <div className="flex items-center justify-center h-64 w-full">
          <Spinner />
        </div>
      ) : (
        <div className="w-full max-w-4xl sm:max-w-5xl lg:max-w-6xl mt-6">
          {error && (
            <div className="text-center text-red-600 font-medium bg-red-100 px-4 py-3 rounded-lg shadow-sm animate-fade-in">
              {error}
            </div>
          )}

          {isSearchActive && student && student.length > 0 && (
            <div className="animate-fade-in">
              <StudentCardList students={student} check={true} />
            </div>
          )}

          {!isSearchActive && (
            <div className="animate-fade-in">
              <StudentChunk />
            </div>
          )}
        </div>
      )}

      {/* Scroll to Top Arrow */}
      {showArrow && (
        <button
          onClick={scrollToTop}
          className="fixed bottom-26 right-6 p-3 bg-gray-200 hover:bg-gray-300 rounded-full shadow-md transition z-40"
          title="Scroll to top"
        >
          <ArrowUp className="w-5 h-5" />
        </button>
      )}

      {/* Logout Button */}
      <motion.button
        whileHover={{ scale: 1.1 }}
        onClick={handleLogout}
        className="fixed bottom-6 right-6 bg-red-500 hover:bg-red-600 text-white p-4 rounded-full shadow-lg flex items-center justify-center group z-50"
        title="Logout"
      >
        <LogOut className="w-6 h-6 transition-all duration-300" />
        <span className="ml-2 font-medium hidden group-hover:inline-block opacity-0 group-hover:opacity-100 transition-opacity duration-300 ease-in-out">
          Logout
        </span>
      </motion.button>
    </div>
  );
};

export default Dashboard;
