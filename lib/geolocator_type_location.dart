import 'package:expenditure_tracker/interface/location.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorTypeLocation extends Location {
  @override
  Future<String> getCurrentPlaceName() async {
    var geolocator = Geolocator();
    var status = await geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.location);

    if (status == GeolocationStatus.granted) {
      final location = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (location == null) {
        return null;
      }
      final placemarks = await geolocator.placemarkFromCoordinates(
          location.latitude, location.longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        String formattedAddress =
            "${placemark.subThoroughfare} ${placemark.thoroughfare},"
            "${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministratieArea},"
            "${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}";
        return formattedAddress;
      }
      return null;
    }
    print("NO LOCATION PERMISSION");
    return null;
  }
}
