export const defaultOptions = {
  responsive: true,
  scales: {
    x: {
      type: 'time',
      time: {
        unit: 'day',
        displayFormats: {
          day: 'yyyy-MM-dd',
          hour: 'yyyy-MM-dd HH:00',
          minute: 'yyyy-MM-dd HH:mm',
        }
      },
      ticks: {
        autoSkip: false,
        maxTicksLimit: 15
      },
      min: '',
      max: '',
    },
    y: {
      beginAtZero: true
    }
  },
  plugins: {
    zoom: {
      zoom: {
        enabled: true,
        drag: {
          enabled: true,
        },
        wheel: {
          enabled: true,
        },
        pinch: {
          enabled: true
        },
        mode: 'x',
        speed: 0.1,
        threshold: 1
      },
      limits: {
        x: {
          min: 'original',
          max: 'original'
        }
      }
    }
  }
}

export const defaultDatasetOptions = {
  backgroundColor: 'rgba(255,99,132,0.2)',
  borderColor: 'rgba(255,99,132,1)',
  borderWidth: 1,
  hoverBackgroundColor: 'rgba(255,99,132,0.4)',
  hoverBorderColor: 'rgba(255,99,132,1)',
  barThickness: 10,
}
