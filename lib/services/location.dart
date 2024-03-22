import 'package:geolocator/geolocator.dart';

// class Location {
//   double? latitude;
//   double? longitude;

//   Future<void> getCurrentLocation() async {
//     try {
//       LocationPermission permission;
//       permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       } else if (permission == LocationPermission.deniedForever) {
//         return Future.error('Location Not Available');
//       } else {
//         throw Exception('Error');
//       }
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.low);

//       latitude = position.latitude;
//       longitude = position.longitude;
//     } catch (e) {
//       print(e);
//     }
//   }
// }

class Location {
  late double latitude;
  late double longitude;

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      } else if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}
