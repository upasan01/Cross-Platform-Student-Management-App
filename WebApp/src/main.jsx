import React, { useEffect, useState } from "react";
import ReactDOM from "react-dom/client";
import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";
import './index.css'
import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import StudentDetails from "./pages/StudentDetails";
import ProtectedRoute from "./components/ProtectedRoute";

// Define your routes
const router = createBrowserRouter([
  {
    path: "/",
    element: <Login />,
  },
  {
    path: "/dashboard",
    element: <ProtectedRoute><Dashboard /></ProtectedRoute>,
  },
  {
    path: "/student/:fullName",
    element: <ProtectedRoute><StudentDetails /></ProtectedRoute>,
  },
]);

// Create a wrapper App component with a loading state
const App = () => {
  const [isAppReady, setIsAppReady] = useState(false);

  useEffect(() => {
    // Simulate initial setup/loading (could be an auth check, etc.)
    setTimeout(() => {
      setIsAppReady(true);
    }, 300); // Delay just enough to prevent flash
  }, []);

  if (!isAppReady) {
    return <div className="flex justify-center items-center h-screen text-xl">Loading...</div>;
  }

  return <RouterProvider router={router} />;
};

// Render
ReactDOM.createRoot(document.getElementById("root")).render(<App />);
