import 'dart:async';

import 'package:expenditure_tracker/interface/location.dart';
import 'package:location/location.dart' as LocationPlugin;
import 'package:geolocator/geolocator.dart';

class LocationTypeLocation extends Location {

  StreamSubscription<Map<String, double>> _subscription;

  @override
  Future<GeoCoordinate> getCurrentLocation() async {
    final locationPlugin = LocationPlugin.Location();
    if (await locationPlugin.hasPermission()) {
      locationPlugin.onLocationChanged().first.then((location) {
        if (location == null) {
          return null;
        }
        return GeoCoordinate(location['latitude'], location['longitude']);
      });
    } else {
      print("NO LOCATION PERMISSION");
    }
    return null;
  }

  @override
  Future<String> getCurrentPlaceName() async {
    final geolocator = Geolocator();
    var location = await getCurrentLocation();
    if (location != null) {
      final placemarks = await geolocator.placemarkFromCoordinates(
        location.latitude, location.longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        String formattedAddress =
          "${placemark.subThoroughfare} ${placemark.thoroughfare},"
          "${placemark.subLocality} ${placemark.locality}, ${placemark
          .subAdministratieArea},"
          "${placemark.administrativeArea} ${placemark.postalCode}, ${placemark
          .country}";
        return formattedAddress;
      }
    }
    return null;
  }

  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
  }
}
