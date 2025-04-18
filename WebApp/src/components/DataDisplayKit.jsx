export const InfoGrid = ({ children }) => (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-3">{children}</div>
);

export const fallback = (value) => {
    if (value === undefined || value === null || value === '') return 'N/A';
    return String(value);
};


export const InfoItem = ({ label, value }) => (
    <p>
        <span className="font-medium text-gray-600">{label}:</span>{' '}
        <span className="text-gray-800">{value}</span>
    </p>
);

export const Section = ({ title, children }) => (
    <section className="bg-white rounded-2xl p-4 shadow-md border border-gray-200 card-details">
        <h4 className="text-lg font-semibold mb-3 text-gray-700 border-b pb-2">{title}</h4>
        {children}
    </section>
);

export const formatDate = (dob) => {
    const dateStr = typeof dob === 'string' ? dob : dob?.$date;
    return dateStr
        ? new Date(dateStr).toLocaleDateString('en-GB', { day: '2-digit', month: '2-digit', year: 'numeric' })
        : 'N/A';
};

export const addressToString = (address) => {
    if (!address) return 'N/A';
    const { fullAddress, city, state, district, pin } = address;
    return `${fallback(fullAddress)}, ${fallback(city)}, ${fallback(district)}, ${fallback(state)} - ${fallback(pin)}`;
};
