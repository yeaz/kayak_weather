var map = null;
var cityMarker = null;
var cityCircle = null;
var hotSpotMarkers = [];
var shadowImage = null;
  
function initializeMap(zoomNum) {
  var mapOptions = {
    center: new google.maps.LatLng(37.77493, -122.41942),
    zoom: zoomNum,
    panControl: false,
    zoomControl: true,
    zoomControlOptions: {
      position: google.maps.ControlPosition.LEFT_CENTER
    },
    mapTypeControl: false,
    scaleControl: true,
    streetViewControl: false,
    overviewMapControl: true,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
     
  map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
       
  shadowImage = new google.maps.MarkerImage(
    'http://maps.gstatic.com/mapfiles/shadow50.png', null, null, new google.maps.Point(10, 34)
  );
   
  cityMarker = new google.maps.Marker({
    position: map.getCenter(),
    map: map,
    visible: false,
    icon: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=|F28520|000000",
    shadow: shadowImage
  });
  
  for(var i = 1; i <= 10; i++) {
    num = i.toString();
    if (i != 10) num = '0' + num;
    marker = new google.maps.Marker({
      position: map.getCenter(),
      map: map,
      visible: false,
      icon: "http://google-maps-icons.googlecode.com/files/yellow" + num + ".png"
    });
    hotSpotMarkers.push(marker);
  }
    
  cityCircle = new google.maps.Circle({
    strokeColor: "#660099",
    strokeOpacity: 0.8,
    strokeWeight: 1,
    fillColor: "#660099",
    fillOpacity: 0.15,
    map: map,
    center: map.getCenter(),
    radius: 0,
    visible: false
  });

  google.maps.event.addListenerOnce(map, 'idle', function(){
    setCityInputStatus();
  });
}

function setCityInputStatus() { 
  selected = $('#city option:selected')
  val = selected.val();
  has_selected = (val != 0);
  text = has_selected ? selected.text() : 'Where Is Your Destination?';
  $('#city-input-status').html(text);
  if (map != null) {
    if (has_selected) {
      cityMarker.setTitle(text);
      $.ajax({
        url: '/get_city_latlng?id=' + val,
        type: 'get',
        dataType: 'json',
        success: function(data) {
          cityPos = new google.maps.LatLng(data.lat, data.lng, false);
          map.panTo(cityPos);
          cityMarker.setPosition(cityPos);
          cityMarker.setVisible(true);
          cityCircle.setCenter(cityPos);
          cityCircle.setVisible(true);
          cityCircle.setRadius($('#distance').val() * 1609.34);
        }
      });
    } else {
      clearCityInputMarkers();
    }
  }
}

function clearCityInputMarkers() { 
  cityMarker.setVisible(false);
  cityMarker.setTitle('');
  cityCircle.setVisible(false);
}
  
function clearHotSpotMarkers(count) {
  if (count === undefined) k = -1;
  else k = count - 1;
  for (var i = 0; i < 10; i++) {
    if (i != k) hotSpotMarkers[i].setVisible(false);
    else hotSpotMarkers[i].setVisible(true);
  }
}
  
function showHotSpotMarkers() {
  for (var i = 0; i < 10; i++) {
    hotSpotMarkers[i].setVisible(true);
  }
}

function processSubmit(geonamesAPI) {
  if ($('#city').val() == 0) {
    $('#result').html("<div class='error_msg'>Please choose your destination</div>");
  } else {
    $('#loading_wrapper').show();
    input = "place=" + $('#city').val() + "&distance=" + $('#distance').val() + '&geonamesAPI=' + geonamesAPI;
    $.ajax({
      url: $('#hot_spots_form').attr('action'),
      type: 'get',
      data: input,
      dataType: 'script',
      complete: function() {
        $('#loading_wrapper').hide();
      }
    });
  }
}

$(document).ready( function() {
  
  setCityInputStatus();

  $('#city').change( function() {
    setCityInputStatus();
  });
   
});
