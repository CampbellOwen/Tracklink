var markers = [];
var routeLines = [];

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

function retrieving()
{
    $("#bus_table").html('<tr><td id="route_spacer"></td></tr><tr><td id="bus_number_left">Retrieving, please wait.</td></tr>');
}

function highlightStop(tablerow)
{
    innerhtml = tablerow.children[1].innerHTML;

    route = tablerow.children[0].innerHTML;
    stopno = innerhtml.slice(0,innerhtml.indexOf(":"))

    clearMarkers();

    $.get("/api/getCoor", {stop: stopno}).success(function(result) {
        var lat_long = {lat: parseFloat(result.lat), lng: parseFloat(result.long)};

        var marker = new google.maps.Marker({
            position: lat_long,
            map: map,
            icon: 'reticle.png'
        });

        markers.push(marker);

    });
    //Highlight Route

    $.get("/api/kmz", {stop: stopno, route:route}).success( function(result) {
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
    });
}

function getRoutes(map, lat_long){
	var lat = lat_long.lat().toFixed(6);
	var lng = lat_long.lng().toFixed(6);
    if (map.getCenter() != lat_long) {
        return;
    }
    $("#bus_table").html('');
    retrieving();
    $.get("/api/location", {lat: lat, long: lng}).success(function(routes){
        if (routes.length == 0) {
	   		$("#bus_table").html('<tr><td id="route_spacer"></td></tr><tr><td id="bus_number_left">No busses nearby, please move the cursor</td></tr>');
        }
        else {
            $("#bus_table").html('');
            for (var i = 0; i < routes.length; i++) {
                $("#bus_table").append('<tr><td id="route_spacer" colspan="2"></td></tr><tr onclick="highlightStop(this)"><td rowspan = "1" id="bus_number_left">' + routes[i].Route + '</td><td id="bus_route_info">' + routes[i].StopNo + ': Leaving ' + routes[i].Name +' towards<br>' + routes[i].Destination +' at '+routes[i].NextBus+'</td></tr>');
            }
        }
    });
}

function initMap() {
	window.map = new google.maps.Map(document.getElementById('map'), {
		center: {lat: 49.27846087175229, lng: -122.9129836081861}, 
		zoom: 15
	});
	map.addListener('center_changed', function(){
		//document.getElementById('lat_long').innerHTML = map.getCenter();
        retrieving();
        var oldPos = map.getCenter();
            var id = setTimeout(function() {
                if (map.getCenter() === oldPos) {
                    console.log("GETTING ROUTES");
                    getRoutes(map, map.getCenter());
                }
            }, 500);
		//getRoutes(map.getCenter());
	});
	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(position) {
			var pos = {lat: position.coords.latitude, lng: position.coords.longitude};
			map.setCenter(pos);
		}, 
		function() {
            getRoutes(map, map.getCenter());
		});
	}
	var marker = new google.maps.Marker({
		map: map,
		icon: 'reticle.png'
	});
	marker.bindTo('position', map, 'center');
}
			
