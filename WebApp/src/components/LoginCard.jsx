import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

const LoginCard = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleLogin = async (event) => {
    event.preventDefault();
    try {
      const response = await axios.post('http://localhost:3000/api/v1/admin/signin', {
        email,
        password,
      });

      
      localStorage.setItem('adminToken', response.data.token);


      alert('Login successful');
      navigate('/dashboard');
    } catch (error) {
      if (error.response && error.response.data && error.response.data.message) {
        alert(`Login failed: ${error.response.data.message}`);
      } else {
        alert('Login failed: Unknown error');
      }
    }
  };

  return (
    <div className="w-[400px] p-8 rounded-xl shadow-lg border border-white/20 bg-white/30 backdrop-blur-md">
      <div className="flex justify-center mb-4">
        <img src="/logo2.png" alt="College Logo" className="w-24 h-24 object-contain rounded-full" />
      </div>

      <form className="space-y-6" onSubmit={handleLogin}>
        <h4 className="text-xl font-medium text-red-400 text-center">Techno Engineering College</h4>

        <div>
          <label htmlFor="email" className="block mb-2 text-sm font-medium text-gray-900">
            Your email
          </label>
          <input
            type="email"
            id="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
            placeholder="xyz@gmail.com"
            required
          />
        </div>

        <div>
          <label htmlFor="password" className="block mb-2 text-sm font-medium text-gray-900">
            Your password
          </label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="••••••••"
            className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
            required
          />
        </div>

        <div className="flex items-center justify-start">
          <input
            id="remember"
            type="checkbox"
            className="w-4 h-4 border border-gray-300 rounded bg-gray-50 focus:ring-3 focus:ring-blue-300"
          />
          <label htmlFor="remember" className="ms-2 text-sm font-medium text-gray-900">
            Remember me
          </label>
        </div>

        <button type="submit" className="purple-button px-5 py-2.5 w-full">
          Login to your account
        </button>
      </form>
    </div>
  );
};

export default LoginCard;
