import 'virtual:windi.css';
// import 'virtual:windi-devtools'; # Problems with port, uses rails port instead of vite
import React from 'react';
import { createRoot } from 'react-dom/client';
import Home from '@pages/Home';

const container = document.getElementById('root');
if (!container) throw new Error('Failed to find root container');
const root = createRoot(container!);
root.render(
  <React.StrictMode>
    <Home />
  </React.StrictMode>
);
