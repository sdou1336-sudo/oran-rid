import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oran_ride/models/ride_request.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oran Ride Captain (سائق)'),
        backgroundColor: const Color(0xFF012C22),
        foregroundColor: Colors.white,
        actions: [
          Row(
            children: [
              Text(_isOnline ? "Online" : "Offline", style: const TextStyle(fontSize: 14)),
              Switch(
                value: _isOnline,
                activeColor: const Color(0xFF10B981),
                onChanged: (val) => setState(() => _isOnline = val),
              ),
            ],
          )
        ],
      ),
      body: !_isOnline
          ? const Center(
              child: Text(
                "You are offline. Go online to see ride requests in Oran.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('trips')
                  .where('status', isEqualTo: 'requested')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Waiting for ride requests in Oran...",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final trip = RideRequest.fromMap(doc.data() as Map<String, dynamic>);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.between,
                              children: [
                                Text(
                                  trip.riderName,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.emerald.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${trip.offeredFare.round()} DZD',
                                    style: const TextStyle(color: Colors.emerald, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.my_location, color: Colors.green, size: 18),
                                const SizedBox(width: 8),
                                Expanded(child: Text('Pickup: ${trip.pickupAddress}')),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.red, size: 18),
                                const SizedBox(width: 8),
                                Expanded(child: Text('Dest: ${trip.destAddress}')),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                    ),
                                    onPressed: () => _ignoreTrip(trip.id),
                                    child: const Text('Ignore'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () => _counterOfferDialog(trip),
                                    child: const Text('Counter Offer'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF012C22),
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () => _acceptOriginalOffer(trip),
                                    child: const Text('Accept'),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _ignoreTrip(String id) {
    // Locally ignore or hide
  }

  void _acceptOriginalOffer(RideRequest trip) async {
    await _firestore.collection('trips').doc(trip.id).update({
      'status': 'accepted',
      'driverId': 'current_driver_uid',
      'driverName': 'Mohamed Capitaine',
      'finalFare': trip.offeredFare,
    });
  }

  void _counterOfferDialog(RideRequest trip) {
    final controller = TextEditingController(text: (trip.offeredFare + 50).round().toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Propose Counter Offer'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Fare in DZD', suffixText: 'DZD'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newFare = double.tryParse(controller.text);
              if (newFare != null) {
                await _firestore.collection('trips').doc(trip.id).update({
                  'counterOffers.current_driver_uid': newFare,
                });
              }
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Send Offer'),
          )
        ],
      ),
    );
  }
}
