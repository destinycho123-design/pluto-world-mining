import React from 'react';

export default function Custom500() {
  return (
    <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
      <div style={{ textAlign: 'center' }}>
        <h1>500 - Server Error</h1>
        <p>Something went wrong. Please try again later.</p>
      </div>
    </div>
  );
}
