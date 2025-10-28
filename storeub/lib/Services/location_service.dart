// lib/services/location_service.dart
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationService {
  final Location _location = Location();

  Future<String> getCurrentAddress() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permission denied.');
      }
    }

    try {
      locationData = await _location.getLocation();

      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address =
            "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}";
        if (address.trim() == ', ,') {
          throw Exception('Could not determine address from coordinates.');
        }
        return address;
      } else {
        throw Exception('No address found for the coordinates.');
      }
    } catch (e) {
      print("Error in LocationService: $e");
      throw Exception('Failed to get location or address: ${e.toString()}');
    }
  }
}
