import 'package:equatable/equatable.dart';

class BusinessEntity extends Equatable {
  final String? id;
  final String businessName;
  final String username;
  final String email;
  final String phoneNumber;
  final String? adoptionPolicy;
  final String? address;
  final Location? location;
  final String role;
  final double? distance;

  const BusinessEntity({
    this.id,
    required this.businessName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.adoptionPolicy,
    this.address,
    this.location,
    required this.role,
    this.distance,
  });

  @override
  List<Object?> get props => [
    id,
    businessName,
    username,
    email,
    phoneNumber,
    adoptionPolicy,
    address,
    location,
    role,
    distance,
  ];
}

class Location extends Equatable {
  final String type;
  final List<double> coordinates;

  const Location({this.type = 'Point', required this.coordinates});

  @override
  List<Object?> get props => [type, coordinates];

  double get latitude => coordinates.isNotEmpty ? coordinates[1] : 0.0;
  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
}
