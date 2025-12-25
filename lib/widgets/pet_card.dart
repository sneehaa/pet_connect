import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetCard extends StatelessWidget {
  const PetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 480,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey.shade100, width: 2),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 85,
            right: -130,
            child: Container(
              height: 400,
              width: 400,
              decoration: const BoxDecoration(
                color: Color(0xFFF9D5B8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 80,
            child: Icon(Icons.pets, size: 270, color: const Color(0xFFD9A070)),
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
                _buildTag("Playful"),
                _buildTag("Energetic"),
                _buildTag("Loyal"),
              ],
            ),
          ),

          Positioned(
            bottom: 60,
            left: 40,
            child: Image.asset("assets/images/murphy.png", height: 400),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFF2C097),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
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
                        "Pet name: Murphy",
                        style: GoogleFonts.alice(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        "Golden Retriever · Adult · Male",
                        style: GoogleFonts.alice(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Rs.20000",
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
