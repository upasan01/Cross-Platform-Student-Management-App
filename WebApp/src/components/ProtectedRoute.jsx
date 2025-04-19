import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom" 
import Spinner from "./Spinner";

const ProtectedRoute = ({ children }) => {
    const navigate = useNavigate();
    const [isAuthenticated, setIsAuthenticated] = useState(null); // null = loading state

    useEffect(() => {
        const token = sessionStorage.getItem("adminToken");

        if (!token) {
            navigate("/");
        } else {
            setIsAuthenticated(true); // Token exists, allow rendering
        }
    }, [navigate]);


    if (isAuthenticated === null) {
        return <> <Spinner /><div className="text-center text-xl mt-10">Checking authentication...</div> </>;
    }

    return children;
};

export default ProtectedRoute;
