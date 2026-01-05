// shelter_detail_page.dart
import 'package:flutter/material.dart';
import 'package:pet_connect/home/shelter_list_page.dart';
import 'package:pet_connect/utils/constant.dart';
import 'package:pet_connect/widgets/pet_list.dart';


// Assuming Shelter class is defined/imported

class ShelterDetailPage extends StatelessWidget {
  final Shelter shelter;
  const ShelterDetailPage({Key? key, required this.shelter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shelterDetails = {
      'Address': '123 Pet Connect Ave, ${shelter.location}',
      'Contact': '(555) 123-4567',
      'Policies': 'Adoption requires a home visit and interview. Fees apply.',
    };

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: kPrimaryColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: kCardColor), // White icon for better contrast
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Text(
                shelter.name,
                style: kHeadlineStyle.copyWith(color: Colors.white, fontSize: 24),
              ),
              background: Image.asset(
                shelter.imageUrl,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.3),
                colorBlendMode: BlendMode.darken,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: kPrimaryColor.withOpacity(0.8),
                  child: Center(child: Text(shelter.name, style: kHeadlineStyle.copyWith(color: Colors.white))),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Shelter Info Section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(Icons.location_on, 'Address', shelterDetails['Address']!),
                      _buildDetailRow(Icons.call, 'Contact Details', shelterDetails['Contact']!),
                      _buildDetailRow(Icons.policy, 'Adoption Policies', shelterDetails['Policies']!),
                      const Divider(height: 30),
                      Text(
                        'Pets Looking for a Home (${shelter.petCount})',
                        style: kTitleStyle,
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                
                // Pet List Widget (with filters)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: PetListWidget(showFilters: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: kPrimaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: kBodyStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(content, style: kBodyStyle.copyWith(fontSize: 14, color: kSecondaryTextColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}