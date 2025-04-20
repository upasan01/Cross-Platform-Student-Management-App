import { useState, React } from "react";
import axios from "axios";
import Spinner from "./Spinner";

const DownloadExcelButton = () => {
  const [loading, setLoading] = useState(false);

  const handleDownload = async () => {
    try {
      setLoading(true);
      const token = sessionStorage.getItem("adminToken");

      const response = await axios.get(
        "http://localhost:3000/v1/api/admin/students/excel",
        {
          headers: { token },
          responseType: "blob",
        }
      );

      // ✅ No need to check response.ok (that’s for fetch, not axios)
      const url = window.URL.createObjectURL(new Blob([response.data]));

      const link = document.createElement("a");
      link.href = url;
      link.setAttribute("download", "students.xlsx");
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    } catch (error) {
      console.error("Download failed:", error);
      alert("Failed to download the Excel file.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <button
      onClick={handleDownload}
      disabled={loading}
      className="blue-button items-center flex"
    >
      {loading ? (
        <>
          <Spinner className="w-5 h-5 mr-2" />
        </>
      ) : (
        <>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth={1.5}
            stroke="currentColor"
            className="w-6 h-6"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5m8.25 3v6.75m0 0l-3-3m3 3l3-3M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125Z"
            />
          </svg>
          <span className="ml-2">Download Excel File</span>
        </>
      )}
    </button>
  );
};

export default DownloadExcelButton;
