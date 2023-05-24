document.addEventListener('DOMContentLoaded', function() {
    // Get the default value from controller
    const defaultValue = <%= @default_value %>;
  
    // Generate the chart using Chartkick
    const chart = new Chartkick.ColumnChart('chart', [['Recommendation', defaultValue]], {
      colors: ['#36a2eb'],
      max: 100, // Adjust the maximum value as needed
      library: { scales: { yAxes: [{ ticks: { beginAtZero: true, max: 100 } }] } }
    });
  });
  