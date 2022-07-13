const BASE_URL = '/api/metrics'

const getMetricsPeriod = async (period: string) => {
  const params = new URLSearchParams({
    per: period
  })
  const url = `${BASE_URL}?${params}`
  const response = await fetch(url)
  if (!response.ok) {
    throw new Error(`Error fetching metrics period: ${response.statusText}`)
  }
  const data = await response.json()
  return data
}

const getMetrics = async (timestamp: string, period: string) => {
  const params = new URLSearchParams({
    timestamp: timestamp,
    per: period
  })
  const url = `${BASE_URL}/list?${params}`
  const response = await fetch(url)
  if (!response.ok) {
    throw new Error(`Error fetching metrics: ${response.statusText}`)
  }
  const data = await response.json()
  return data
}

const createMetric = async (metric) => {
  const response = await fetch(BASE_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(metric)
  })
  return response;
}


export default {
  getMetricsPeriod,
  getMetrics,
  createMetric
}
