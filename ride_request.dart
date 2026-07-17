class RideRequest {
  final String id;
  final String riderId;
  final String riderName;
  final String pickupAddress;
  final double pickupLat;
  final double pickupLng;
  final String destAddress;
  final double destLat;
  final double destLng;
  final double offeredFare;
  final String status; // 'requested', 'accepted', 'arriving', 'in_progress', 'completed', 'cancelled'
  final String category; // 'car', 'motorcycle'
  final String? driverId;
  final String? driverName;
  final double? finalFare;
  final Map<String, dynamic> counterOffers; // driverId -> proposedFare

  RideRequest({
    required this.id,
    required this.riderId,
    required this.riderName,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.destAddress,
    required this.destLat,
    required this.destLng,
    required this.offeredFare,
    required this.status,
    required this.category,
    this.driverId,
    this.driverName,
    this.finalFare,
    this.counterOffers = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'riderId': riderId,
      'riderName': riderName,
      'pickupAddress': pickupAddress,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'destAddress': destAddress,
      'destLat': destLat,
      'destLng': destLng,
      'offeredFare': offeredFare,
      'status': status,
      'category': category,
      'driverId': driverId,
      'driverName': driverName,
      'finalFare': finalFare,
      'counterOffers': counterOffers,
    };
  }

  factory RideRequest.fromMap(Map<String, dynamic> map) {
    return RideRequest(
      id: map['id'] ?? '',
      riderId: map['riderId'] ?? '',
      riderName: map['riderName'] ?? '',
      pickupAddress: map['pickupAddress'] ?? '',
      pickupLat: (map['pickupLat'] ?? 0.0).toDouble(),
      pickupLng: (map['pickupLng'] ?? 0.0).toDouble(),
      destAddress: map['destAddress'] ?? '',
      destLat: (map['destLat'] ?? 0.0).toDouble(),
      destLng: (map['destLng'] ?? 0.0).toDouble(),
      offeredFare: (map['offeredFare'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'requested',
      category: map['category'] ?? 'car',
      driverId: map['driverId'],
      driverName: map['driverName'],
      finalFare: map['finalFare'] != null ? (map['finalFare']).toDouble() : null,
      counterOffers: map['counterOffers'] ?? {},
    );
  }
}
