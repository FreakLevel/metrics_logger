import React, { useState } from "react";
import { DateTimePicker, LocalizationProvider } from '@mui/x-date-pickers';
import { AdapterMoment } from '@mui/x-date-pickers/AdapterMoment';
import { TextField } from '@mui/material';
import { format } from "@utils/datetime";

const Modal = ({
  close,
  create
}) => {

  const [date, setDate] = useState<any>(new Date());
  const [name, setName] = useState('Metric #');
  const [value, setValue] = useState(1);

  const changeValue = (value, type) => {
    if (type === 'name') {
      setName(value);
    } else if (type === 'value') {
      value = Number(value);
      if (isNaN(value) || value <= 0) value = 1;
      setValue(value);
    } else {
      setDate(value);
    }
  }

  const createMetric = () => {
    let timestamp = null
    if (date['_isAMomentObject']) {
      timestamp = format(date.toDate());
    } else {
      timestamp = format(date);
    }
    create({
      name,
      value,
      timestamp
    });
  }

  const renderTextFieldDateInput = (inputProps) => {
    return(
    <TextField {...inputProps} helperText={null} />
  )}

  return (
    <div id="authentication-modal" tabIndex={-1} aria-hidden="true" className="fixed top-30 left-1/2 z-50 w-full overflow-x-hidden overflow-y-auto h-modal md:h-full transform -translate-x-14rem">
      <div className="relative w-full h-full max-w-md p-4 md:h-auto">
        <div className="relative bg-white rounded-lg shadow dark:bg-gray-700">
          <button onClick={() => close()} type="button" className="absolute top-3 right-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center dark:hover:bg-gray-800 dark:hover:text-white">
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd"></path></svg>  
          </button>
          <div className="px-6 py-6 lg:px-8">
            <h3 className="mb-4 text-xl font-medium text-gray-900 dark:text-white">Add new metric</h3>
            <section className="space-y-6">
              <div>
                <label htmlFor="name" className="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Name</label>
                <input value={name} onChange={(e) => changeValue(e.target.value, 'name')} type="text" name="name" id="name" className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white" placeholder="Metric #" required />
              </div>
              <div>
                <input value={value} min={1} onBlur={e => changeValue(e.target.value, 'value')} onChange={(e) => changeValue(e.target.value, 'value')} type="number" name="value" id="value" className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white" required />
              </div>
              <div>
                <label htmlFor="datetime" className="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Datetime (UTC)</label>
                <LocalizationProvider dateAdapter={AdapterMoment}>
                  <DateTimePicker value={date} ampm={false} renderInput={inputProps => renderTextFieldDateInput(inputProps)} onChange={(value) => changeValue(value, 'date')} />
                </LocalizationProvider>
              </div>
              <button onClick={createMetric} type="button" className="w-full text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">Add metric</button>
            </section>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Modal;