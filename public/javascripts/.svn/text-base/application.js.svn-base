// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Ajax.Responders.register({
     onCreate: function() {
      if($('progress') && Ajax.activeRequestCount>0)
      Effect.Appear('progress',{duration:0.5,queue:'end'});
     },
    
     onComplete: function() {
      if($('progress') && Ajax.activeRequestCount==0)
      Effect.Fade('progress',{duration:0.5,queue:'end'});
    }
    });


/***	
	function initialize() {
	if (GBrowserIsCompatible() && typeof places != 'undefined' ) {
	var map = new GMap2(document.getElementById("map" ));
	map.setCenter(new GLatLng(-93.7056, 32.5447), 5);
	map.addControl(new GLargeMapControl());
	// Clicking the marker will hide it
	function createMarker(latlng, place) {
	var marker = new GMarker(latlng);
	var html="<strong>" +place.name+"</strong><br />" +place.address;
	GEvent.addListener(marker,"click" , function() {
	map.openInfoWindowHtml(latlng, html);
	});
	return marker;
	}
	var bounds = new GLatLngBounds;
	for (var i = 0; i < places.length; i++) {
	var latlng=new GLatLng(places[i].lat,places[i].lng)
	bounds.extend(latlng);
	map.addOverlay(createMarker(latlng, places[i]));
	}
	map.setCenter(bounds.getCenter(),map.getBoundsZoomLevel(bounds));
	}
	}
	window.onload=initialize;
	window.onunload=GUnload;
	
	/***
	 * Excerpted from "Advanced Rails Recipes",
	 * published by The Pragmatic Bookshelf.
	 * Copyrights apply to this code. It may not be used to create training material, 
	 * courses, books, articles, and the like. Contact us if you are in doubt.
	 * We make no guarantees that this code is fit for any purpose. 
	 * Visit http://www.pragmaticprogrammer.com/titles/fr_arr for more book information.
	
	function initialize() { 
	  if (GBrowserIsCompatible() && typeof households != 'undefined') {
	    var map = new GMap2(document.getElementById("map"));
	    map.setCenter(new GLatLng(37.4419, -122.1419), 13);
	    map.addControl(new GLargeMapControl());

	    // Clicking the marker will hide it
	    function createMarker(latlng, household) {
	      var marker = new GMarker(latlng);
	      var html="<strong>"+household.name+"</strong><br />"+household.address;
	      GEvent.addListener(marker,"click", function() {
	        map.openInfoWindowHtml(latlng, html);
	      });
	      return marker;
	    }

	    var bounds = new GLatLngBounds;
	    for (var i = 0; i < households.length; i++) {
	      var latlng=new GLatLng(households[i].lat,households[i].lng)
	      bounds.extend(latlng);
	      map.addOverlay(createMarker(latlng, households[i]));
	    }
	    map.setCenter(bounds.getCenter(),map.getBoundsZoomLevel(bounds));
	  }
	}  
	window.onload=initialize;
	window.onunload=GUnload;  

***/

Element.addMethods({
	
	toggleClassName: function(element, classnameA, classnameB) {
		if (!(element = $(element))) return;
		element.hasClassName(classnameA) ?
			element.className = classnameA :
			element.className = classnameB;
		return element;
	}
});
