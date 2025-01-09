// Configuration pour Mapbox

class MapboxConfig {
  static const String accessToken = 'pk.eyJ1Ijoic2ltb2FpdGVsZ2F6emFyIiwiYSI6ImNtMzVzeXYyazA2bWkybHMzb2Fxb3p6aGIifQ.ORYyvkZ2Z1H8WmouDkXtvQ';
  static const String mapId = 'mapbox/streets-v11';
  static const String baseUrl = 'https://api.mapbox.com';
  
  static String getDirectionsUrl(double startLng, double startLat, double endLng, double endLat) {
    return '$baseUrl/directions/v5/mapbox/driving/$startLng,$startLat;$endLng,$endLat'
           '?geometries=geojson&access_token=$accessToken';
  }
  
  static String getGeocodingUrl(String query) {
    return '$baseUrl/geocoding/v5/mapbox.places/$query.json'
           '?access_token=$accessToken'
           '&language=fr'
           '&limit=5';
  }
  
  static String getReverseGeocodingUrl(double lng, double lat) {
    return '$baseUrl/geocoding/v5/mapbox.places/$lng,$lat.json'
           '?access_token=$accessToken'
           '&language=fr';
  }
}
