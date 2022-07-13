import React, { useEffect, useState, forwardRef, useImperativeHandle } from 'react';
import metricsService from '@services/metrics-service';
import Chart from '@components/Chart';
import { IDataset } from '@components/Chart/interfaces';
import Table from '@components/Table';
import { format } from '@utils/datetime';

const Content = forwardRef((_, ref) => {
  const [period, setPeriod] = useState('day');
  const [dataset, setDataset] = useState<IDataset[]>([]);
  const [loading, setLoading] = useState(true);
  const [metrics, setMetrics] = useState([]);
  const [chartProps, setChartProps] = useState({});

  useImperativeHandle(ref, () => ({
    reload: () => {
      loadData();
    }
  }));

  useEffect(() => {
    loadData();
  }, [period]);

  useEffect(() => {
    setChartProps({
      dataset,
      period,
      loading,
      handlerChangePeriod,
      handlerSelectDatetime
    });
  }, [dataset, period, loading]);

  const loadData = () => {
    setLoading(true);
    metricsService.getMetricsPeriod(period).then(data => {
      data = data.map(item => ({ x: new Date(item.x), y: item.y }));
      setDataset(data);
      setMetrics([]);
      setLoading(false);
    }).catch(error => {});
  }

  const handlerChangePeriod = (period: string) => {
    setPeriod(period);
  }

  const handlerSelectDatetime = (index: number) => {
    if (dataset.length == 0) return;

    const timestamp = format(dataset[index].x, period);
    console.log()
    metricsService.getMetrics(timestamp, period).then(data => {
      setMetrics(data);
    }).catch(error => {});
  }

  return (
    <div
      className='bg-gray-500 h-[calc(100vh-7.5rem)] flex flex-col items-center flex-grow-1 justify-start gap-10 overflow-y-auto'
    >
      <section className='min-w-3/4 mt-10 flex justify-center'>
        <Chart {...chartProps} />
      </section>
      <hr />
      <section className='min-w-3/4 mb-10 flex justify-center'>
        <Table metrics={metrics} period={period} />
      </section>
    </div>
  );
})

export default Content;
