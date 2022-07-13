import React from "react";
import { format } from "@utils/datetime";

const Table = ({ metrics, period }) => {
  const render = () => {
    if (metrics.length == 0) return voidRender();
    return renderTable();
  }

  const voidRender = () => (
    <h1 className="text-light-500 text-2xl">
      Click on some bar in the graphic to read their metrics
    </h1>
  )

  const renderTable = () => (
    <table className="w-1/2 shadow-2xl border-2 border-black bg-light-500 text-center">
      <thead className="border-2 border-black">
        <tr>
          <th className="px-4 py-2">Metric</th>
          <th className="px-4 py-2">Value</th>
          <th className="px-4 py-2">Date / DateTime</th>
        </tr>
      </thead>
      <tbody>
        {metrics.map((metric) => (
          renderMetric(metric)
        ))}
      </tbody>
    </table>
  )

  const renderMetric = (metric) => (
    <tr key={metric.id}>
      <td className="px-4 py-2">
        <span className="text-gray-700">
          {metric.name}
        </span>
      </td>
      <td className="px-4 py-2">
        <span className="text-gray-700">
          {metric.value}
        </span>
      </td>
      <td className="px-4 py-2">
        <span className="text-gray-700">
          {format(metric.timestamp, period)}
        </span>
      </td>
    </tr>
  )

  return (
    <>
      { render() }
    </>
  );
}

export default Table;
