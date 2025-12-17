import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_connect/auth/login.dart';
import 'package:pet_connect/widgets/swipeable_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6EC),
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.20,
            right: 15,
            child: Transform.rotate(
              angle: 0.5,
              child: Icon(
                Icons.pets,
                size: 60,
                color: const Color(0xFFFFCCAD).withOpacity(0.7),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Find Your",
                    style: GoogleFonts.alice(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Furry",
                        style: GoogleFonts.alice(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                  Text(
                    "Favorite",
                    style: GoogleFonts.alice(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // White Bottom Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.40,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 80, 30, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Find your perfect pet companion",
                      style: GoogleFonts.alice(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildPaginationDot(isActive: false),
                            _buildPaginationDot(isActive: true),
                            _buildPaginationDot(isActive: false),
                          ],
                        ),

                        SwipeableButton(
                          onSwipeComplete: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Cat Image
          Positioned(
            bottom: size.height * 0.33,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 350,
                child: Image.asset(
                  'assets/images/onboarding1.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      height: 6,
      width: isActive ? 24 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey[800] : Colors.grey[400],
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
