import React, { useEffect } from "react";
import ReactDOM from "react-dom/client";
import {
  createBrowserRouter,
  RouterProvider,
  Navigate,
} from "react-router-dom";
import './index.css'
import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import StudentDetails from "./pages/StudentDetails";
import ProtectedRoute from "./components/ProtectedRoute";

const checkAuth = () => {
  // Check if the token exists in either localStorage or sessionStorage
  const token = localStorage.getItem('adminToken');
  return token ? true : false;
};

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

ReactDOM.createRoot(document.getElementById("root")).render(
    <RouterProvider router={router} />
);
