import 'package:pet_connect/features/business/business_dashboard/domain/entity/adoption_entity.dart';

class BusinessAdoptionModel extends BusinessAdoptionEntity {
  const BusinessAdoptionModel({
    super.id,
    required super.petId,
    required super.userId,
    required super.businessId,
    super.status,
    super.applicationDetails,
    super.rejectionReason,
    super.payment,
    super.appliedAt,
    super.createdAt,
    super.updatedAt,
  });

  factory BusinessAdoptionModel.fromJson(Map<String, dynamic> json) {
    return BusinessAdoptionModel(
      id: json['_id'],
      petId: json['petId'],
      userId: json['userId'],
      businessId: json['businessId'],
      status: json['status'],
      rejectionReason: json['rejectionReason'],
      applicationDetails: json['applicationDetails'] != null
          ? ApplicationDetailsModel.fromJson(json['applicationDetails'])
          : null,
      payment: json['payment'] != null
          ? PaymentDetailsModel.fromJson(json['payment'])
          : null,
      appliedAt: json['appliedAt'] != null
          ? DateTime.parse(json['appliedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'petId': petId,
      'userId': userId,
      'businessId': businessId,
      'status': status,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      if (applicationDetails != null)
        'applicationDetails': (applicationDetails as ApplicationDetailsModel)
            .toJson(),
      if (payment != null) 'payment': (payment as PaymentDetailsModel).toJson(),
      if (appliedAt != null) 'appliedAt': appliedAt!.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

class ApplicationDetailsModel extends ApplicationDetailsEntity {
  const ApplicationDetailsModel({
    required super.fullName,
    required super.phoneNumber,
    required super.address,
    required super.homeType,
    required super.hasYard,
    super.employmentStatus,
    super.numberOfAdults,
    super.numberOfChildren,
    super.hasOtherPets = false,
    super.otherPetsDetails,
    super.hoursPetAlone,
    super.previousPetExperience,
    super.message,
  });

  factory ApplicationDetailsModel.fromJson(Map<String, dynamic> json) {
    return ApplicationDetailsModel(
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      homeType: json['homeType'] ?? '',
      hasYard: json['hasYard'] ?? false,
      employmentStatus: json['employmentStatus'],
      numberOfAdults: json['numberOfAdults'],
      numberOfChildren: json['numberOfChildren'],
      hasOtherPets: json['hasOtherPets'] ?? false,
      otherPetsDetails: json['otherPetsDetails'],
      hoursPetAlone: json['hoursPetAlone'],
      previousPetExperience: json['previousPetExperience'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'homeType': homeType,
      'hasYard': hasYard,
      if (employmentStatus != null) 'employmentStatus': employmentStatus,
      if (numberOfAdults != null) 'numberOfAdults': numberOfAdults,
      if (numberOfChildren != null) 'numberOfChildren': numberOfChildren,
      'hasOtherPets': hasOtherPets,
      if (otherPetsDetails != null) 'otherPetsDetails': otherPetsDetails,
      if (hoursPetAlone != null) 'hoursPetAlone': hoursPetAlone,
      if (previousPetExperience != null)
        'previousPetExperience': previousPetExperience,
      if (message != null) 'message': message,
    };
  }
}

class PaymentDetailsModel extends PaymentDetailsEntity {
  const PaymentDetailsModel({
    super.paymentId,
    super.isPaid = false,
    super.amount,
    super.paidAt,
  });

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailsModel(
      paymentId: json['paymentId'],
      isPaid: json['isPaid'] ?? false,
      amount: json['amount'] != null
          ? (json['amount'] as num).toDouble()
          : null,
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (paymentId != null) 'paymentId': paymentId,
      'isPaid': isPaid,
      if (amount != null) 'amount': amount,
      if (paidAt != null) 'paidAt': paidAt!.toIso8601String(),
    };
  }
}
