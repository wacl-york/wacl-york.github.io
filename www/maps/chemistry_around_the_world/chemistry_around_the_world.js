// A pretty specific function
function marker_ship_start(pair, name = "finish") {
  
  var marker = L.marker(pair, {
    
    icon: icon_start()
    
  }).bindPopup(name);
  
  return marker;
  
}


// Create object
var markers_clustered = L.markerClusterGroup();

// Do things to object
markers_with_popups = clustered_markers_with_popups(
  spatial_object, 
  type = "chemistry_around_the_world"
);

// Add to map
markers_clustered.addLayer(markers_with_popups);
map.addLayer(markers_clustered);


// Add lines
var line_rv_lance = L.geoJson(sp_rv_lance, 
  style = {
    "color": "blue",
    "weight": 2
  });

var marker_rv_lance = marker_ship_start(
  [69.68, 18.99], 
  name = "RV Lance ship track"
);

// var arrows_rv_lance = arrows(line_rv_lance);

var line_rss_james_cook = L.geoJson(sp_rss_james_cook, 
  style = {
    "color": "blue",
    "weight": 2
  });

var marker_rss_james_cook = marker_ship_start(
  [50.89, -1.39], 
  name = "RSS James Cook ship track"
); 

// Create group of tracks
group_tracks = L.layerGroup([
  line_rv_lance, 
  marker_rv_lance,
  line_rss_james_cook,
  marker_rss_james_cook
]);

// Add icon, toggle fails here
var icon_image = L.controlCredits({
  width: 400,
  height: 200,
  image: "images/icons/small_icon.jpg",
  link: "https://www.york.ac.uk/chemistry/research/wacl/",
  text: "WACL home"
}).addTo(map);


// Add some layer control
var overlay_layers = {
  "Display markers?": markers_clustered,
  "Display ship tracks?": group_tracks
};

// Add layer control to map
L.control.layers(base_maps, overlay_layers).addTo(map);

// Set bounds, a nudge west to keep New Zealand and logo on screen
map.setView(new L.LatLng(10, 30), 3);


// Use objects for centering
// var boundaries = new L.featureGroup([
//   markers_clustered
// ]);

// Set boundaries
// map.fitBounds(boundaries.getBounds());
