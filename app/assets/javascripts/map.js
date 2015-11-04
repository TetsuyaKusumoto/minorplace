$(function() {
  handler = Gmaps.build('Google');
  handler.buildMap({provider: {}, internal: {id: 'map'}}, function(){
  markers = handler.addMarkers([
    {
      lat: 35.20, lng: 139.49
    }
    ],
    {
      draggable: true
    }
  );
  handler.getMap().setZoom(6);
  handler.map.centerOn({lat: 35.397, lng: 139.644});
  //handler.bounds.extendWith(markers);
//  handler.bounds.extendWith(pmarker);
  //handler.fitMapToBounds();
  google.maps.event.addListener(markers[0].serviceObject, 'dragend', function() {
    updateFormLocation(this.getPosition());
  });
});
function updateFormLocation(latLng) {
  $('#latitude').val(latLng.lat());
  $('#longitude').val(latLng.lng());
}
});
