function buildMetadata(sample) {

  // @TODO: Complete the following function that builds the metadata panel
    d3.json(`/metadata/${sample}`).then(data => {
      // Use d3 to select the panel with id of #sample-metadata
      let PANEL = d3.select("#sample-metadata");
 
      // use html function to clear out any information in the box
      PANEL.html("");
 
      Object.entries(data).forEach(([key, value]) => {
        PANEL.append("h5").text(`${key}: :${value}`);
      })
    // BONUS: Build the Gauge Chart
    buildGauge(data.WFREQ);
    }
  )
 }
 
 function buildCharts(sample) {
 
  // @TODO: Use `d3.json` to fetch the sample data for the plots
 
    // @TODO: Build a Bubble Chart using the sample data
 
 
    // HINT: You will need to use slice() to grab the top 10 sample_values,
    // otu_ids, and labels (10 each).
    d3.json(`/samples/${sample}`).then(data => {
      const otu_ids = data.otu_ids;
      const otu_labels = data.otu_labels;
      const sample_values = data.sample_values;
 
      // Build a Bubble Chart
      var bubbleLayout = {
        margin: { t: 0 },
        
        hovermode: "closest",
        xaxis: { title: "OTU ID" }
      };
      var bubbleData = [
        {
          x: otu_ids,
          y: sample_values,
          text: otu_labels,
          mode: "markers",
          marker: {
            size: sample_values,
            color: otu_ids,
            colorscale: "Earth"
          }
        }
      ];
 
      Plotly.newPlot("bubble", bubbleData, bubbleLayout);
    }
  )
 }
 
 // @TODO: Build a Pie Chart
 
 function populatePieChart(sample){
  console.log("Pie chart data");
  sample["type"] = "pie";
  console.log(sample);
 
  var pie = document.querySelector(".germs-pie")
 
  var data = [sample];
  var layout = {
      height: 400,
      width: 500,
      title: "Top 10 Operational Taxonomic Units <br> (OTU) found in this sample"
    };
 
  Plotly.newPlot("pie",data,layout);
 }
 
 function init() {
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");
 
  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {
    sampleNames.forEach((sample) => {
      selector
        .append("option")
        .text(sample)
        .property("value", sample);
    });
 
    // Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);
  });
 }
 
 function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  buildCharts(newSample);
  buildMetadata(newSample);
 }
 
 // Initialize the dashboard
 init();