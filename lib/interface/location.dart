abstract class Location {
  Future<GeoCoordinate> getCurrentLocation();
  Future<String> getCurrentPlaceName();
}

class GeoCoordinate {
  final num latitude;
  final num longitude;
  GeoCoordinate(this.latitude,this.longitude);
}