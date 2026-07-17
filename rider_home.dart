import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oran_ride/models/ride_request.dart';
import 'package:uuid/uuid.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  GoogleMapController? _mapController;
  final LatLng _oranCenter = const LatLng(35.6976, -0.6331); // Center of Oran, Algeria
  
  String? _pickupAddress = "Front de Mer";
  LatLng _pickupLatLng = const LatLng(35.7061, -0.6276);
  String? _destAddress = "Aéroport d'Oran - Es-Sénia";
  LatLng _destLatLng = const LatLng(35.6262, -0.6133);
  
  double _offeredFare = 400.0; // Proposed Fare in DZD
  String _vehicleCategory = 'car'; // car or motorcycle
  
  bool _isRequesting = false;
  String? _activeRequestId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oran Ride (زبون)'),
        backgroundColor: const Color(0xFF10B981),
      ),
      body: Stack(
        children: [
          // Google Map Grid
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _oranCenter, zoom: 12),
            onMapCreated: (c) => _mapController = c,
            markers: {
              Marker(markerId: const MarkerId('pickup'), position: _pickupLatLng, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
              Marker(markerId: const MarkerId('dest'), position: _destLatLng, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
            },
          ),
          
          // inDrive Bidding Input Dialog
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Offer Your Fare - Oran', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.emerald, size: 30),
                          onPressed: () => setState(() => _offeredFare = (_offeredFare - 50).clamp(150, 2000)),
                        ),
                        Text('${_offeredFare.round()} DZD', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.emerald)),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.emerald, size: 30),
                          onPressed: () => setState(() => _offeredFare += 50),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      icon: const Icon(Icons.send),
                      label: const Text('Broadcast Bidding Offer'),
                      onPressed: _submitRideRequest,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _submitRideRequest() async {
    final requestId = const Uuid().v4();
    final request = RideRequest(
      id: requestId,
      riderId: 'current_rider_uid',
      riderName: 'Sid Ahmed',
      pickupAddress: _pickupAddress!,
      pickupLat: _pickupLatLng.latitude,
      pickupLng: _pickupLatLng.longitude,
      destAddress: _destAddress!,
      destLat: _destLatLng.latitude,
      destLng: _destLatLng.longitude,
      offeredFare: _offeredFare,
      status: 'requested',
      category: _vehicleCategory,
    );

    await FirebaseFirestore.instance.collection('trips').doc(requestId).set(request.toMap());
    setState(() {
      _isRequesting = true;
      _activeRequestId = requestId;
    });
  }
}
