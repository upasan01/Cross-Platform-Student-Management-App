import React, { useState, useEffect, useRef, useCallback } from "react";
import axios from "axios";
import Spinner from "./Spinner";
import StudentCardList from "./StudentCardList";

const StudentListChunk = () => {
  const [students, setStudents] = useState([]);
  const [page, setPage] = useState(1);
  const [hasMore, setHasMore] = useState(true);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const loadedStudentIds = useRef(new Set());
  const observer = useRef();

  // IntersectionObserver to detect when last student is visible
  const lastStudentRef = useCallback(
    (node) => {
      if (loading) return;
      if (observer.current) observer.current.disconnect();

      observer.current = new IntersectionObserver((entries) => {
        const entry = entries[0];
        console.log("👀 IntersectionObserver entry:", entry);

        if (entry.isIntersecting && hasMore) {
          console.log("📦 Last student in view, loading next page...");
          setPage((prevPage) => prevPage + 1);
        }
      });

      if (node) observer.current.observe(node);
    },
    [loading, hasMore]
  );

  useEffect(() => {
    const fetchStudents = async () => {
      setLoading(true);
      setError(null);

      try {
        const token = sessionStorage.getItem("adminToken");

        const response = await axios.get(
          "http://localhost:3000/api/v1/admin/studentsChunk",
          {
            params: { page, limit: 10 },
            headers: { token },
          }
        );

        console.log(`✅ Fetched page ${page}:`, response.data);

        const newStudents = response.data.data || [];

        if (newStudents.length === 0 || newStudents.length < 10) {
          console.log("⛔ No more students to load.");
          setHasMore(false);
        }

        const uniqueNewStudents = newStudents.filter((student) => {
          if (!student._id) {
            console.warn("⚠️ Student missing _id:", student);
            return false;
          }

          if (loadedStudentIds.current.has(student._id)) {
            return false;
          }

          loadedStudentIds.current.add(student._id);
          return true;
        });

        console.log(`➕ Adding ${uniqueNewStudents.length} new unique students`);

        setStudents((prev) => [...prev, ...uniqueNewStudents]);
      } catch (err) {
        console.error("❌ Error fetching students:", err);
        setError("Failed to load students. Please try again.");
      } finally {
        setLoading(false);
      }
    };

    fetchStudents();
  }, [page]);

  return (
    <div className="p-4">
      {error && <p className="text-red-500 text-center mb-4">{error}</p>}
      <StudentCardList students={students} lastStudentRef={lastStudentRef} />
      {loading && <Spinner />}
      {!hasMore && students.length > 0 && (
        <p className="text-center mt-4 text-gray-500">No more students to load.</p>
      )}
      {!hasMore && students.length === 0 && !loading && (
        <p className="text-center mt-4 text-gray-500">No students found.</p>
      )}
    </div>
  );
};

export default StudentListChunk;
