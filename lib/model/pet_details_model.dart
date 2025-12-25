import 'package:flutter/material.dart';

class PetDetails {
  final String name;
  final String breedAgeGender;
  final String price;
  final String petImagePath; 
  final Color backgroundColor;
  final Color iconColor;
  final List<String> tags;
  final String icon;
  
  const PetDetails({
    required this.name,
    required this.breedAgeGender,
    required this.price,
    required this.petImagePath,
    required this.backgroundColor,
    required this.iconColor,
    required this.tags,
    required this.icon,
  });
}