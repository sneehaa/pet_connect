import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_connect/widgets/category_item.dart';
import 'package:pet_connect/widgets/custom_navbar.dart';
import 'package:pet_connect/widgets/pet_card.dart';
import 'package:pet_connect/widgets/pet_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onCategorySelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPetDetail = petDetails[_selectedIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, Justine 🐾",
                        style: GoogleFonts.alice(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Good morning",
                        style: GoogleFonts.alice(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 114, 113, 113),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color.fromARGB(255, 205, 205, 205),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/bell.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/loupe-3.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Search by breed, size, or name",
                            style: GoogleFonts.alice(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 113, 113, 113),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.tune_rounded, color: Colors.black),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,

                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryItem(
                      label: category.label,
                      imagePath: category.imagePath,

                      isSelected: index == _selectedIndex,

                      onTap: () => _onCategorySelected(index),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              PetCard(details: selectedPetDetail),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
