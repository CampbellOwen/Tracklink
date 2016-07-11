function getRoutes(lat_long){
	var lat = lat_long.lat().toFixed(6);
	var lng = lat_long.lng().toFixed(6);
	var url = "http://api.translink.ca/rttiapi/v1/stops?apikey=QUprTm0ALxtTt4npEjl6&lat=" + lat + "&long=" + lng; 
	var yql = 'http://query.yahooapis.com/v1/public/yql?q=' + encodeURIComponent('select * from xml where url="' + url + '"') + '&format=xml&callback=?';
	//document.getElementById('debug1').innerHTML = url;
	$.getJSON(yql, function (data) {
	   	var xml = $.parseXML(data.results[0]);
	   	$xml = $(xml);
	   	//$("#routes_ex").html("<b>Stops Nearby:</b><br>");
	   	$("#bus_table").html('');
	   	if($xml.find("Stop").length == 0){
	   		$("#bus_table").html('<tr><td id="route_spacer"></td></tr><tr><td id="bus_number_left">No busses nearby, please move the cursor</td></tr>');
	   	}
	   	var routesUnique = new Array();
	   	var stopsUnique = new Array();
	   	$xml.find("Stop").each( function() {
	      	var stop = $(this).find("StopNo");
	      	var lati = $(this).find("Latitude");
	      	var longi = $(this).find("Longitude");
	      	var routes = $(this).find("Routes");
	      	var locName = $(this).find("Name");
	      	var dir = locName.text().split(' ', 1);
	 		var splitName = locName.text().substr(3); 
	      	var routesSplit = routes.text().split(', ');
	       	for(var i=0; i<routesSplit.length; i++){
	       		if( routesSplit[i] != ''){
	       			if(stopsUnique.indexOf(splitName) != -1){
						$("#bus_table").append('<tr><td id="route_spacer" colspan="2"></td></tr><tr><td rowspan = "1" id="bus_number_left">' + routesSplit[i] + '</td><td id="bus_route_info">' + stop.text() + ': ' + locName.text() +'<br>Placeholder 2 to 1</td></tr>');
		       			routesUnique.push(routesSplit[i]);
		       			stopsUnique.push(splitName);
					}else if(routesUnique.indexOf(routesSplit[i]) == -1){
	       				$("#bus_table").append('<tr><td id="route_spacer" colspan="2"></td></tr><tr><td rowspan = "1" id="bus_number_left">' + routesSplit[i] + '</td><td id="bus_route_info">' + stop.text() + ': ' + locName.text() +'<br>Placeholder 1 to 2</td></tr>');
		       			routesUnique.push(routesSplit[i]);
		       			stopsUnique.push(splitName);
					}
	       		}
	       	}
	      	
	      	
	       	
	    });
});
}

function initMap() {
	var map = new google.maps.Map(document.getElementById('map'), {
		center: {lat: 49.27846087175229, lng: -122.9129836081861}, 
		zoom: 15
	});
	map.addListener('center_changed', function(){
		//document.getElementById('lat_long').innerHTML = map.getCenter();
		getRoutes(map.getCenter());
	});
	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(position) {
			var pos = {lat: position.coords.latitude, lng: position.coords.longitude};
			map.setCenter(pos);
		}, 
		function() {
			//document.getElementById('lat_long').innerHTML = map.getCenter();
			getRoutes(map.getCenter());
			//api me
		});
	}
	var marker = new google.maps.Marker({
		map: map,
		icon: 'reticle.png'
	});
	marker.bindTo('position', map, 'center');
}
			