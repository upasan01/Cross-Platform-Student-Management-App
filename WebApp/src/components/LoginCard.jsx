import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

const LoginCard = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleLogin = async (event) => {
    event.preventDefault();
    setLoading(true);
    try {
      const response = await axios.post('http://localhost:3000/api/v1/admin/signin', {
        email,
        password,
      });

      sessionStorage.setItem('adminToken', response.data.token);
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
            className="w-full p-2.5 text-sm text-gray-900 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
            placeholder="xyz@gmail.com"
            required
          />
        </div>

        <div>
          <label htmlFor="password" className="block mb-2 text-sm font-medium text-gray-800">
            Your password
          </label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="••••••••"
            className="w-full p-2.5 text-sm text-gray-900 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
            required
          />
        </div>

        <div className="flex items-center">
          <input
            id="remember"
            type="checkbox"
            className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500"
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
          {loading ? 'Logging in...' : 'Login to your account'}
        </button>
      </form>
    </div>
  );
};

export default LoginCard;
