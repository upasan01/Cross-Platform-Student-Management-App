import React, { useState, useEffect } from "react";
import { Navigate } from "react-router-dom";
import Spinner from "./Spinner";  // Assuming you have a Spinner component for loading state

const ProtectedRoute = ({ children }) => {
  const [loading, setLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem('adminToken') || sessionStorage.getItem('adminToken');
    if (token) {
      setIsAuthenticated(true);
    } else {
      setIsAuthenticated(false);
    }
    setLoading(false);  // Once the check is complete, update loading state
  }, []);

  if (loading) {
    // While loading, show a loading spinner
    return (
      <div className="flex justify-center items-center h-screen">
        <Spinner />
      </div>
    );
  }

  if (!isAuthenticated) {
    // If no token is found, redirect to login page
    return <Navigate to="/" replace />;
  }

  return children;
};

export default ProtectedRoute;
