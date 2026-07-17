import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream current location for active tracking in Oran
  Stream<Position> get liveLocationStream {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 10 meters updates
      ),
    );
  }

  // Save current driver coordinates to FireStore for active passenger search
  Future<void> updateDriverLocation(double lat, double lng) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _db.collection('active_drivers').doc(uid).set({
        'driverId': uid,
        'location': GeoPoint(lat, lng),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }
  }
}
