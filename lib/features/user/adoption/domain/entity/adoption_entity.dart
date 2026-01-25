import 'package:equatable/equatable.dart';

class UserAdoptionEntity extends Equatable {
  final String? id;
  final String petId;
  final String userId;
  final String businessId;
  final String status;
  final UserApplicationDetailsEntity? applicationDetails;
  final String? rejectionReason;
  final PaymentDetailsEntity? payment;
  final DateTime? appliedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserAdoptionEntity({
    this.id,
    required this.petId,
    required this.userId,
    required this.businessId,
    this.status = "pending",
    this.applicationDetails,
    this.rejectionReason,
    this.payment,
    this.appliedAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    petId,
    userId,
    businessId,
    status,
    applicationDetails,
    rejectionReason,
    payment,
    appliedAt,
    createdAt,
    updatedAt,
  ];

  UserAdoptionEntity copyWith({
    String? id,
    String? petId,
    String? userId,
    String? businessId,
    String? status,
    UserApplicationDetailsEntity? applicationDetails,
    String? rejectionReason,
    PaymentDetailsEntity? payment,
    DateTime? appliedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAdoptionEntity(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      status: status ?? this.status,
      applicationDetails: applicationDetails ?? this.applicationDetails,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      payment: payment ?? this.payment,
      appliedAt: appliedAt ?? this.appliedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserApplicationDetailsEntity extends Equatable {
  final String fullName;
  final String phoneNumber;
  final String address;
  final String homeType;
  final bool hasYard;
  final String? employmentStatus;
  final int? numberOfAdults;
  final int? numberOfChildren;
  final bool hasOtherPets;
  final String? otherPetsDetails;
  final int? hoursPetAlone;
  final String? previousPetExperience;
  final String? message;

  const UserApplicationDetailsEntity({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.homeType,
    required this.hasYard,
    this.employmentStatus,
    this.numberOfAdults,
    this.numberOfChildren,
    this.hasOtherPets = false,
    this.otherPetsDetails,
    this.hoursPetAlone,
    this.previousPetExperience,
    this.message,
  });

  @override
  List<Object?> get props => [
    fullName,
    phoneNumber,
    address,
    homeType,
    hasYard,
    employmentStatus,
    numberOfAdults,
    numberOfChildren,
    hasOtherPets,
    otherPetsDetails,
    hoursPetAlone,
    previousPetExperience,
    message,
  ];
}

class PaymentDetailsEntity extends Equatable {
  final String? paymentId;
  final bool isPaid;
  final double? amount;
  final DateTime? paidAt;

  const PaymentDetailsEntity({
    this.paymentId,
    this.isPaid = false,
    this.amount,
    this.paidAt,
  });

  @override
  List<Object?> get props => [paymentId, isPaid, amount, paidAt];
}
