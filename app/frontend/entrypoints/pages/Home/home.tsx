import React, { useRef } from 'react';
import Chart from '@components/Chart';
import Navbar from '@components/Navbar';
import Content from '@components/Content';

const Home = () => {
  const contentRef = useRef<Content>(null);

  const reload = () => {
    if (contentRef.current) {
      contentRef.current.reload();
    }
  }

  return (
    <div className="flex-row w-full h-screen">
      <Navbar reload={reload} />
      <Content ref={contentRef} />
    </div>
  );
}

export default Home;
