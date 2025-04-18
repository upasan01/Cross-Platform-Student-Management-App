import React, { useState } from 'react';
import { SearchIcon } from 'lucide-react';

const Search = ({ onSearch }) => {
  const [input, setInput] = useState('');
  const [category, setCategory] = useState('email');

  const handleSubmit = (e) => {
    e.preventDefault();
    onSearch(input.trim(), category);
    setInput('');
  };

  return (
    <form
      onSubmit={handleSubmit}
      className="max-w-4xl mx-auto px-6 py-10"
    >
      <div className="flex items-center shadow-lg rounded-2xl max-w-4xl sm:w-2xl overflow-hidden transition-all focus-within:ring-2 focus-within:ring-blue-500">
        <select
          className="bg-gray-100 sm:text-sm text-xs px-4 py-3 font-medium text-gray-700 border-r border-gray-300 focus:outline-none"
          value={category}
          onChange={(e) => setCategory(e.target.value)}
        >
          <option value="email">Email</option>
          <option value="uniRollNumber">Roll Number</option>
          <option value="regNumber">Reg Number</option>
          <option value="fullName">Name</option>
        </select>

        <div className="relative flex-grow">
          <span className="absolute inset-y-0 left-3 flex items-center text-gray-400">
            <SearchIcon size={18} />
          </span>
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder={`Search by ${category}`}
            className="w-full pl-10 pr-4 py-3 sm:text-sm text-gray-900 placeholder-gray-400 bg-white focus:outline-none text-xs"
            required
          />
        </div>

        <button
          type="submit"
          className="bg-blue-600 hover:bg-blue-700 text-white sm:px-6 sm:py-3 sm:text-sm font-medium transition-all text-xs px-3 py-[12.8px] flex items-center justify-center"
        >
          {/* Show icon only on small screens */}
          <SearchIcon size={16} className="block sm:hidden" />
          <span className="hidden sm:block">Search</span>
        </button>
      </div>
    </form>
  );
};

export default Search;
