import React, { useEffect, useState } from 'react';
import {
  Chart as ChartJS,
  LinearScale,
  TimeScale,
  CategoryScale,
  BarElement,
  Tooltip,
  ChartEvent,
  ActiveElement,
  ChartData,
} from 'chart.js';
import 'chartjs-adapter-date-fns';
import zoomPlugin from 'chartjs-plugin-zoom';
import { Bar } from 'react-chartjs-2';
import { ThreeDots } from 'react-loader-spinner';
import Select from 'react-select';
import { defaultOptions, defaultDatasetOptions } from './config';
import { IDataset } from './interfaces';

ChartJS.register(
  LinearScale,
  TimeScale,
  CategoryScale,
  BarElement,
  Tooltip,
  zoomPlugin
)

interface IProps {
  dataset: IDataset[];
  period: string;
  loading: boolean;
  handlerSelectDatetime: (index: number) => void;
  handlerChangePeriod: (period: string) => void;
}

const PERIODS = [
  { value: 'day', label: 'day' },
  { value: 'hour', label: 'hour' },
  { value: 'minute', label: 'minute' }
];

const Chart = ({
  dataset,
  period,
  loading,
  handlerSelectDatetime,
  handlerChangePeriod
}: IProps) => {
  const [options, setOptions] = useState({});
  const [data, setData] = useState({  datasets: [] });

  useEffect(() => {
    if (dataset == undefined) return
    if (dataset.length == 0) return

    updateOptions();
    const datasets = [Object.assign({ data: dataset }, defaultDatasetOptions)];
    const finalData = { datasets: datasets };
    setData(finalData);
  }, [dataset])

  const updateOptions = () => {
    const optionMod = Object.assign({}, defaultOptions);
    optionMod.scales.x.time.unit = period;
    optionMod.scales.x.min = dataset[0].x;
    optionMod.scales.x.max = dataset.slice(-1)[0].x;
    if (optionMod['onClick'] == undefined) {
      optionMod['onClick'] = (_event: ChartEvent, activeElements: ActiveElement[]) => {
        const element = activeElements[0];
        if (element == undefined) return;
        handlerSelectDatetime(element.index);
      }
    }
    setOptions(optionMod);
  }

  const showChart = () => (
    <div className='w-full'>
      <div className='flex flex-row justify-center items-baseline'>
        <h1 className='text-2xl'>Average value of metrics per </h1>
        <Select
          className='ml-2 mr-2 text-2xl'
          options={PERIODS}
          value={PERIODS.find(item => item.value == period)}
          onChange={(event) => {if (event) handlerChangePeriod(event.value)}}
        />
        <h1 className='text-2xl'> (UTC Time)</h1>
      </div>
      <Bar data={data} options={options} />
    </div>
  )

  return (
    <div className='lg:w-full xl:w-7/8 2xl:w-10/11 2xl:max-w-6/9 bg-light-50 border-dark-400 py-16 px-32 flex justify-center text-center'>
      {
        loading && Object.keys(options).length === 0 ?
          <ThreeDots color='#000' />
          : showChart()
      }
    </div>
  );
}

export default Chart;
