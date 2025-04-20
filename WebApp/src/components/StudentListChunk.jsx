import React, { useState, useEffect, useRef, useCallback } from "react";
import axios from "axios";
import Spinner2 from "./Spinner2";
import StudentCardList from "./StudentCardList";

const StudentListChunk = () => {
  const [students, setStudents] = useState([]);
  const [page, setPage] = useState(1);
  const [hasMore, setHasMore] = useState(true);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const observer = useRef();
  const loadedIds = useRef(new Set());

  const lastStudentRef = useCallback(
    (node) => {
      if (loading) return;
      if (observer.current) observer.current.disconnect();

      observer.current = new IntersectionObserver(([entry]) => {
        if (entry.isIntersecting && hasMore) {
          setPage((prevPage) => prevPage + 1);
        }
      });

      if (node) observer.current.observe(node);
    },
    [loading, hasMore]
  );

  const fetchStudents = async () => {
    setLoading(true);
    setError(null);

    try {
      const token = sessionStorage.getItem("adminToken");
      const { data } = await axios.get(
        `${import.meta.env.VITE_BASE_URL}/api/v1/admin/studentsChunk`,
        {
          params: { page, limit: 10 },
          headers: { token },
        }
      );

      const fetched = data.data || [];

      if (fetched.length < 10) setHasMore(false);

      const unique = fetched.filter((s) => {
        if (!s._id || loadedIds.current.has(s._id)) return false;
        loadedIds.current.add(s._id);
        return true;
      });

      setStudents((prev) => [...prev, ...unique]);
    } catch (err) {
      setError("Failed to load students.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchStudents();
  }, [page]);

  return (
    <div className="p-4">
      {error && <p className="text-red-500 text-center mb-4">{error}</p>}

      <StudentCardList students={students} lastStudentRef={lastStudentRef} check={false}/>

      {loading && <div><Spinner2 /></div>}

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
