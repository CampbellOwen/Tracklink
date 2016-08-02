var markers = [];
var routeLines = [];
var ajaxCalls = [];

function clearMarkers()
{
    for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(null);
    }
    markers = []

    for (var i = 0; i < routeLines.length; i++) {
        routeLines[i].setMap(null);
    }
    routeLines = []
}

function abortCalls()
{
    for (var i = 0; i < ajaxCalls.length; i++) {
        console.log(ajaxCalls[i]);
        ajaxCalls[i].abort();
    }
    ajaxCalls = []
}

function retrieving()
{
    $("#bus_table").html('<tr><td id="wait">Retrieving, please wait.</td></tr>');
}

function highlightStop(tablerow, typ)
{
    if(typ==0){
      innerhtml = tablerow.children[1].innerHTML;
      route = tablerow.children[0].innerHTML;
      stopno = innerhtml.slice(0,innerhtml.indexOf(":"))
    }else{
      innerhtml = tablerow.children[0].innerHTML;
      route = tablerow.previousSibling.children[0].innerHTML;
      stopno = innerhtml.slice(0, innerhtml.indexOf(":"))
    }

    clearMarkers();

    ajaxCalls.push($.get("/api/getCoor", {stop: stopno}).success(function(result) {
        var lat_long = {lat: parseFloat(result.lat), lng: parseFloat(result.long)};
        var marker = {
          url: 'stop.png',
          scaledSize: new google.maps.Size(40, 49),
          origin: new google.maps.Point(0,0),
          anchor: new google.maps.Point(20, 49)
        };
        var marker = new google.maps.Marker({
            position: lat_long,
            map: map,
            icon: marker
        });

        markers.push(marker);

    }));
    
    //Highlight Route
    ajaxCalls.push($.get("/api/kmz", {stop: stopno, route:route}).success( function(result) {
        console.log(result[0]);
        kmzurl = result[0];


        var kmzLayer = new google.maps.KmlLayer(
                          kmzurl,
                          {
                              suppressInfoWindows: true,
                              map: map,
                              preserveViewport: true
                          });

        routeLines.push(kmzLayer);
    }));
}

function getRoutes(map, lat_long, refresh_flag){
	var lat = lat_long.lat().toFixed(6);
	var lng = lat_long.lng().toFixed(6);
    if (map.getCenter() != lat_long) {
        return;
    }
    abortCalls();
    if(!refresh_flag){
      $("#bus_table").html('');
    retrieving();
    }
    ajaxCalls.push($.get("/api/location", {lat: lat, long: lng}).success(function(routes){
        if(refresh_flag){
          $("#bus_table").html('');
        }
        if (routes == "404" || routes.length == 0) {

	   		$("#bus_table").html('<tr><td id="wait">No busses nearby, please move the cursor</td></tr>');
        }
        else {
            $("#bus_table").html('');
            for (var i = 0; i < routes.length; i++) {
                if(i<routes.length-1 && routes[i].Route == routes[i+1].Route){
                  //FIXED BELOW
                  $("#bus_table").append(
                    '<tr onclick="highlightStop(this, 0)">'+
                      '<td rowspan="2" id="bus_number_left">'+ 
                        routes[i].Route +
                        '<div id="twitter-place">Send Feedback</div>' +
                      '</td>' +
                      '<td id="bus_route_info">' + 
                        routes[i].StopNo + ': Leaving ' + routes[i].Name +' towards<br>' + routes[i].Destination +' at '+routes[i].NextBus+
                      '</td>' +
                    '</tr>' +
                    '<tr onclick="highlightStop(this, 1)">'+
                    '<td id="bus_route_info">' + 
                      routes[i+1].StopNo + ': Leaving ' + routes[i+1].Name +' towards<br>' + routes[i+1].Destination +' at '+routes[i+1].NextBus +
                    '</td>' +
                    '</tr>' +
                    '<tr>' +
                      '<td id="route_spacer" colspan="2"></td>' +
                    '</tr>');
                  //FIXED ABOVE
                  i++;
                }else{
                  $("#bus_table").append(
                    '<tr onclick="highlightStop(this, 0)">'+
                      '<td rowspan="1" id="bus_number_left">'+ 
                        routes[i].Route +
                        '<div id="twitter-place">Send Feedback</div>' +
                      '</td>' +
                      '<td id="bus_route_info">' + 
                        routes[i].StopNo + ': Leaving ' + routes[i].Name +' towards<br>' + routes[i].Destination +' at '+routes[i].NextBus+
                      '</td>' +
                    '</tr>' +
                    '<tr>' +
                      '<td id="route_spacer" colspan="2"></td>' +
                    '</tr>');
                }
                
            }
        }
    }));
}

function initMap() {
	window.map = new google.maps.Map(document.getElementById('map'), {
		center: {lat: 49.27846087175229, lng: -122.9129836081861}, 
		zoom: 16,
    minZoom: 10,
    mapTypeControl: false,
    //---
    styles: [
      {
        featureType: "transit.station.bus",
        stylers: [
          {visibility: "off"}
        ]
      }
    ]
    //---
	});
	map.addListener('center_changed', function(){
		//document.getElementById('lat_long').innerHTML = map.getCenter();
    retrieving();
    var oldPos = map.getCenter();
    var id = setTimeout(function() {
      if (map.getCenter() === oldPos) {
        console.log("GETTING ROUTES");
        getRoutes(map, oldPos, 0);
      }
    }, 1000);
		//getRoutes(map.getCenter());
	});
	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(position) {
			var pos = {lat: position.coords.latitude, lng: position.coords.longitude};
			map.setCenter(pos);
		}, 
		function() {
            getRoutes(map, map.getCenter(), 0);
		});
	}
  var icon = {
    url: 'reticle.png',
    scaledSize: new google.maps.Size(34, 34),
    origin: new google.maps.Point(0,0),
    anchor: new google.maps.Point(17, 17)
  };
	var marker = new google.maps.Marker({
		map: map,
		icon: icon,
    clickable: false
	});
	marker.bindTo('position', map, 'center');
  var rad = new google.maps.Circle({
    strokeColor: '#0060a8',
    strokeOpacity: 0.9,
    strokeWeight: 1,
    fillColor: '#0060a8',
    radius: 500,
    map: map
  });
  rad.bindTo('center', marker, 'position');
  var refresher = setInterval(function(){
    var curPos = map.getCenter();
    if (map.getCenter() === curPos) {
      console.log("REFRESHING ROUTES");
      getRoutes(map, curPos, 1);
    }
  }, 60000);
}
