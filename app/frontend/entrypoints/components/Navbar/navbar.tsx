import React, { useState } from 'react';
import Modal from '@components/Modal';
import metricsService from '@services/metrics-service';

const Navbar = ({
  reload
}) => {
  const [showModal, setShowModal] = useState(false);

  const closeModal = () => ( setShowModal(false) );
  const newMetric = (metric) => {
    metricsService.createMetric(metric).then(response => {
      if (response.ok) {
        reload();
        closeModal();
      } else {
        console.log('Error');
      }
    }).catch(error => {
      console.log('Error');
    });
  }

  return (
    <nav className="bg-dark-600 h-30 flex flex-row-reverse items-center">
      { showModal && <Modal close={closeModal} create={newMetric} /> }
      <h1
        className='fixed left-1/2 transform -translate-x-1/2 text-4xl text-orange-700'
      >
        Metrics Logger
      </h1>
      <button
        onClick={() => setShowModal(true)}
        type='button'
        data-modal-toggle="authentication-modal"
        className='w-40 h-10 mr-12 p-0.5 mb-2 mr-2 text-sm font-medium
                  rounded-lg bg-gradient-to-br from-red-400 to-red-800'
      >
        <span className='relative px-10 py-2.5 transition-all ease-in duration-75 bg-dark-600 rounded-md text-light-50'>New Metric</span>
      </button>
    </nav>
  );
}

export default Navbar;
