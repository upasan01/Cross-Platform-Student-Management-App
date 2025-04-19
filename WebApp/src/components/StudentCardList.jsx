import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ChevronDown } from 'lucide-react';
import FetchDetails from './FetchDetails';
import { fallback } from './DataDisplayKit';

const StudentCardList = ({ students }) => {
    const [expandedId, setExpandedId] = useState(null);

    const toggleCard = (id) => {
        setExpandedId((prev) => (prev === id ? null : id));
    };

    if (!Array.isArray(students)) {
        return <div className="text-center text-gray-500">No students found.</div>;
    }

    return (

        <div className=" flex flex-col items-center space-y-6">
            <p className="text-gray-700 font-semibold text-lg mb-2">
                {students.length} student{students.length !== 1 ? 's' : ''} found
            </p>

            {students.map((student) => {
                const isExpanded = expandedId === student._id;

                return (
                    <motion.div
                        key={student._id}
                        layout
                        className={`bg-white w-full max:w-4xl rounded-xl shadow-md overflow-hidden ${isExpanded ? '' : 'hover-card'}`}
                        transition={{
                            layout: { duration: 0.3, type: 'spring', stiffness: 300, damping: 25 },
                        }}
                    >
                        {/* Header */}
                        <div
                            className="flex items-center justify-between p-4  sm:ml-20 cursor-pointer"
                            onClick={() => toggleCard(student._id)}
                        >
                            <div className="flex align-baseline w-full justify-around sm:space-x-8 sm:justify-start sm:ml-6">
                                <img
                                    src={student.imageUrl}
                                    alt="Student"
                                    className="avatar"
                                />
                                <div className="text-center sm:text-left px-4 ">
                                    <h3 className="sm:text-2xl text-lg font-bold text-gray-800 mt-6">
                                        {fallback(student.studentDetails.fullName)}
                                    </h3>
                                    <p className="text-gray-600 mt-2 sm:text-base text-xs">
                                        <strong>Roll No:</strong>{fallback(student.studentDetails.rollno)}</p>
                                    <p className="text-gray-600 mt-2 sm:text-base text-xs">
                                        <strong>Email:</strong> {fallback(student.studentDetails.email)}
                                    </p>
                                </div>
                            </div>
                            <motion.div
                                animate={{ rotate: isExpanded ? 180 : 0 }}
                                transition={{ duration: 0.25 }}
                            >
                                <ChevronDown className="text-gray-500" />
                            </motion.div>
                        </div>

                        {/* Expand/Collapse Panel */}
                        <AnimatePresence initial={false}>
                            {isExpanded && (
                                <motion.div
                                    key="expand"
                                    initial={{ opacity: 0, scaleY: 0.95 }}
                                    animate={{ opacity: 1, scaleY: 1 }}
                                    exit={{ opacity: 0, scaleY: 0.95 }}
                                    transition={{ duration: 0.1, ease: 'easeOut', type: 'spring' }}
                                    className="origin-top overflow-hidden"
                                >
                                    <motion.div layout className="p-6 pt-4">
                                        <FetchDetails student={student} />
                                    </motion.div>
                                </motion.div>
                            )}
                        </AnimatePresence>
                    </motion.div>
                );
            })}
        </div>
    );
};
export default StudentCardList;
