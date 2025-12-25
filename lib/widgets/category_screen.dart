import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_connect/widgets/category_item.dart';
import 'package:pet_connect/widgets/pet_card.dart';
import 'package:pet_connect/widgets/pet_data.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
      appBar: AppBar(title: const Text("Pet Categories"), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              const SizedBox(height: 30),
              Text(
                "Featured Pet",
                style: GoogleFonts.alice(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 15),

              PetCard(details: selectedPetDetail),
            ],
          ),
        ),
      ),
    );
  }
}
