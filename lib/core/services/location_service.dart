import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> updateDriverLocation(String driverId) async {
  print("========== LOCATION ==========");

  bool enabled = await Geolocator.isLocationServiceEnabled();
  print("Service Enabled = $enabled");

  if (!enabled) return;

  LocationPermission permission =
      await Geolocator.checkPermission();

  print("Permission = $permission");

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    print("Permission After Request = $permission");
  }

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return;
  }

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  print("Latitude = ${position.latitude}");
  print("Longitude = ${position.longitude}");

  await _firestore.collection('drivers').doc(driverId).update({
    'latitude': position.latitude,
    'longitude': position.longitude,
    'lastLocationUpdate': FieldValue.serverTimestamp(),
  });

  print("LOCATION UPDATED");
}
}