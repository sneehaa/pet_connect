import 'package:flutter/material.dart';
import 'package:pet_connect/home/shelter_detail_page.dart';
import 'package:pet_connect/home/shelter_list_page.dart';
import 'package:pet_connect/utils/constant.dart';
import 'package:pet_connect/widgets/custom_navbar.dart';
import 'package:pet_connect/widgets/pet_list.dart';

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
    // We will use dummyPets from pet_list_widgets.dart for the home list
    final List<Pet> availablePets = dummyPets
        .where((p) => p.status == 'Available')
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Section ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, Justine 🐾",
                        style: kHeadlineStyle.copyWith(fontSize: 26),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Good morning",
                        style: kBodyStyle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: kSecondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kCardColor,
                      border: Border.all(color: Colors.grey.shade300),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: kTextColor,
                      size: 24,
                    ),
                    // If you are using your asset:
                    // child: Image.asset('assets/icons/bell.png', width: 24, height: 24),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // --- Search Bar (Existing Code) ---
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 55,
                      decoration: BoxDecoration(
                        color: kCardColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            size: 24,
                            color: kSecondaryTextColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Search by breed, size, or name",
                            style: kBodyStyle.copyWith(
                              fontSize: 14,
                              color: kSecondaryTextColor,
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
                      color: kCardColor,
                      border: Border.all(color: Colors.grey.shade400),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.tune_rounded, color: kTextColor),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- New Section: Shelters Nearby (a.i.) ---
              _buildHomeSectionHeader(
                title: "Shelters Near You",
                onViewAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShelterListPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),

              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dummyShelters
                      .take(3)
                      .length, // Show top 3 shelters
                  itemBuilder: (context, index) {
                    final shelter = dummyShelters[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == dummyShelters.take(3).length - 1
                            ? 0
                            : 15.0,
                      ),
                      child: _ShelterHomeCard(shelter: shelter),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // --- New Section: Pets Available (a.iii.) ---
              _buildHomeSectionHeader(
                title: "Pets Ready for Adoption",
                onViewAll: () {
                  // Navigate to a standalone PetList page if you create one,
                  // or just the first shelter's pet list for demonstration
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShelterListPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),

              // Display 2x2 grid of pet cards
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: availablePets.length,
                itemBuilder: (context, index) {
                  return PetCardWidget(pet: availablePets[index]);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(), // Your existing widget
    );
  }

  // --- Reusable Home Widgets ---

  Widget _buildHomeSectionHeader({
    required String title,
    required VoidCallback onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kTitleStyle.copyWith(fontSize: 20)),
        TextButton(
          onPressed: onViewAll,
          child: Text(
            'View All',
            style: kBodyStyle.copyWith(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// Simplified shelter card for the horizontal Home Screen list
class _ShelterHomeCard extends StatelessWidget {
  final Shelter shelter;
  const _ShelterHomeCard({required this.shelter});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShelterDetailPage(shelter: shelter),
          ),
        );
      },
      child: Container(
        width: 200, // Fixed width for horizontal scrolling
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shelter.name,
              style: kTitleStyle.copyWith(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: kSecondaryTextColor,
                ),
                const SizedBox(width: 4),
                Text(
                  shelter.location,
                  style: kBodyStyle.copyWith(
                    fontSize: 12,
                    color: kSecondaryTextColor,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '${shelter.petCount} available pets',
              style: kBodyStyle.copyWith(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
