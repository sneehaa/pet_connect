import 'package:flutter/material.dart';
import 'package:pet_connect/model/pet_details_model.dart';


final List<PetDetails> petDetails = [
  const PetDetails(
    name: "Murphy",
    breedAgeGender: "Golden Retriever · Adult · Male",
    price: "Rs.20000",
    petImagePath: "assets/images/murphy.png",
    backgroundColor: Color(0xFFF9D5B8),
    iconColor: Color(0xFFD9A070),
    tags: ["Playful", "Energetic", "Loyal"],
    icon: "assets/icons/paw.png",
  ),

  const PetDetails(
    name: "Whiskers",
    breedAgeGender: "Siamese · Young · Female",
    price: "Rs.15000",
    petImagePath: "assets/images/cats.png",
    backgroundColor: Color(0xFFC7E2E4),
    iconColor: Color(0xFF8DB2B6),
    tags: ["Independent", "Cuddly", "Quiet"],
    icon: "assets/icons/paw.png",
  ),

  const PetDetails(
    name: "Bugs",
    breedAgeGender: "Holland Lop · Adult · Male",
    price: "Rs.8000",
    petImagePath: "assets/images/rabbit.png", // Rabbit image
    backgroundColor: Color(0xFFD2E8D0),
    iconColor: Color(0xFF90B58D),
    tags: ["Gentle", "Affectionate"],
    icon: "assets/icons/paw.png",
  ),
];
