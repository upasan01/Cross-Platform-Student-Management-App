import React, { useState } from 'react';
import { SearchIcon } from 'lucide-react';

const Search = ({ onSearch }) => {
  const [input, setInput] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    onSearch(input);
    setInput('');
  };

  return (
    <form onSubmit={handleSubmit} className="sm:flex sm:justify-center w-full mx-auto px-6 py-10">
      <div className="flex items-center shadow-2xl rounded-2xl max-w-4xl sm:w-2xl overflow-hidden transition-all focus-within:ring-2 focus-within:ring-blue-500">

        <div className="relative flex-grow">
          <span className="absolute inset-y-0 left-3 flex items-center text-gray-400">
            <SearchIcon size={18} />
          </span>
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Search by email or name"
            className="w-full pl-10 pr-4 py-3 sm:text-sm text-gray-900 placeholder-gray-400 bg-white focus:outline-none text-xs"
            required
          />
        </div>

        <button
          type="submit"
          className="bg-blue-600 hover:bg-blue-700 text-white sm:px-6 sm:py-3 sm:text-sm font-medium transition-all text-xs px-3 py-[12.8px] flex items-center justify-center">
          <SearchIcon size={16} className="block sm:hidden" />
          <span className="hidden sm:block">Search</span>
        </button>
      </div>
    </form>
  );
};

export default Search;
