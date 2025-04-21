import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import Spinner from './Spinner';

const LoginCard = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [rememberMe, setRememberMe] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    // Check if the token exists in localStorage and redirect to dashboard if so
    const token = localStorage.getItem('adminToken') || sessionStorage.getItem('adminToken');
    if (token) {
      navigate('/dashboard', { replace: true });
    }
  }, [navigate]);

  const handleLogin = async (event) => {
    event.preventDefault();
    setLoading(true);
    try {
      const response = await axios.post(`${import.meta.env.VITE_BASE_URL}/api/v1/admin/signin`, {
        email,
        password,
      });
      // Save the token in the appropriate storage based on remember me checkbox
      const { token } = response.data; 

      sessionStorage.setItem('adminToken', token);  
      if (rememberMe) {
        localStorage.setItem('adminToken', token);  
      } 

      // Redirect to dashboard
      navigate('/dashboard', { replace: true });
    } catch (error) {
      alert(
        error.response?.data?.message
          ? `Login failed: ${error.response.data.message}`
          : 'Login failed: Unknown error'
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="w-full sm:w-lg max-w-md mx-auto p-6 sm:p-10 rounded-2xl shadow-2xl border border-white/30 sm:bg-white/30 sm:backdrop-blur-md bg-white">
      <div className="flex justify-center mb-6">
        <img
          src="/logo2.png"
          alt="College Logo"
          className="w-20 h-20 sm:w-24 sm:h-24 object-contain rounded-full shadow-md"
        />
      </div>

      <form className="space-y-6" onSubmit={handleLogin}>
        <h4 className="text-center text-lg sm:text-2xl font-bold text-red-600 mb-4">
          Techno Engineering College, Banipur
        </h4>

        <div>
          <label htmlFor="email" className="block mb-2 text-sm font-medium text-gray-800">
            Your email
          </label>
          <input
            type="email"
            id="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="w-full p-2.5 text-sm text-gray-900 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 focus:bg-gray-200"
            placeholder="xyz@gmail.com"
            required
          />
        </div>

        <div>
          <label htmlFor="password" className="block mb-2 text-sm font-medium text-gray-800 ">
            Your password
          </label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="••••••••"
            className="w-full p-2.5 text-sm text-gray-900 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 focus:bg-gray-200"
            required
          />
        </div>

        <div className="flex items-center">
          <input
            id="remember"
            type="checkbox"
            className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500"
            checked={rememberMe}
            onChange={(e) => setRememberMe(e.target.checked)} // Toggle remember me state
          />
          <label htmlFor="remember" className="ml-2 text-sm text-gray-700">
            Remember me
          </label>
        </div>

        <button
          type="submit"
          disabled={loading}
          className="w-full  login-button"
        >
          {loading ? <Spinner/> : 'Login to your account'}
        </button>
      </form>
    </div>
  );
};

export default LoginCard;
