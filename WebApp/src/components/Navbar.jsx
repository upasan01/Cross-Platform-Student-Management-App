import React from 'react';

const Navbar = () => {
  return (
    <header className="fixed top-2 left-0 right-0 z-50 bg-transparent">
      <div className="w-full px-4 sm:px-10">
        <div className="bg-white/80 backdrop-blur-md shadow-md border-b border-white/20 rounded-lg">
          <div className="max-w-7xl h-20 mx-auto px-6 py-4 flex items-center justify-between">
            <div className="w-full flex items-center space-x-4 md:justify-between">
                <div>
              <img
                src="/logo2.png"
                alt="College Logo"
                className="sm:w-16 sm:h-16 w-14 h-14 rounded-full  shadow-sm"
              />
              </div>
              <div className="text-base sm:text-3xl font-bold text-red-600 font-sans tracking-wide">
                Techno Engineering College, Banipur
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Navbar;
