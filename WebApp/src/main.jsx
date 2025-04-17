import React from "react";
import ReactDOM from "react-dom/client";
import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";
import './index.css'
import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import StudentDetails from "./pages/StudentDetails";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Login />, 
  },
  {
    path: "/dashboard",
    element: <Dashboard />,  
  },
  {
    path:"/student/:fullName",
    element: <StudentDetails />,
  },
]);

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>
);
