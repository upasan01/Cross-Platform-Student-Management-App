import React from 'react';

const LoginCard = () => {
  return (
    <div className="w-[400px] p-8 rounded-xl shadow-lg border border-white/20 bg-white/30 backdrop-blur-md">
      <div className="flex justify-center mb-4">
        <img src="/logo2.png" alt="College Logo" className="w-24 h-24 object-contain rounded-full" />
      </div>

      <form className="space-y-6">
        <h4 className="text-xl font-medium text-red-400 text-center">Techno Engineering College</h4>

        <div>
          <label htmlFor="email" className="block mb-2 text-sm font-medium text-gray-900">
            Your email
          </label>
          <input
            type="email"
            name="email"
            id="email"
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
            name="password"
            id="password"
            placeholder="••••••••"
            className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
            required
          />
        </div>

        <div className="flex items-center justify-around">
          <div className="flex items-center">
            <input
              id="remember"
              type="checkbox"
              className="w-4 h-4 border border-gray-300 rounded bg-gray-50 focus:ring-3 focus:ring-blue-300"
            />
            <label htmlFor="remember" className="ms-2 text-sm font-medium text-gray-900">
              Remember me
            </label>
          </div>
          <a href="#" className="text-sm text-blue-700 hover:underline mx-0.5">
            Lost Password?
          </a>
        </div>

        <button type="submit" className="purple-button px-5 py-2.5 w-full">
          Login to your account
        </button>
      </form>
    </div>
  );
};

export default LoginCard;
