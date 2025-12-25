import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_connect/model/pet_details_model.dart';

class PetCard extends StatelessWidget {
  final PetDetails details;

  const PetCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 480,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey.shade100, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Circle
          Positioned(
            top: 85,
            right: -130,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                color: details.backgroundColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 80,
            child: Image.asset(
              details.icon,
              height: 270,
              color: details.iconColor,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Distance",
                  style: GoogleFonts.alice(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "0.9 km nearby",
                  style: GoogleFonts.alice(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 25),
                Text(
                  "Tags",
                  style: GoogleFonts.alice(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                ...details.tags.map((tag) => _buildTag(tag)),
              ],
            ),
          ),

          Positioned(
            bottom: 60,
            left: 40,
            child: Image.asset(details.petImagePath, height: 350),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                color: details.backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(30),
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pet name: ${details.name}",
                        style: GoogleFonts.alice(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        details.breedAgeGender,
                        style: GoogleFonts.alice(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    details.price,
                    style: GoogleFonts.alice(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.alice(
          color: Colors.black.withOpacity(0.6),
          fontSize: 15,
        ),
      ),
    );
  }
}
