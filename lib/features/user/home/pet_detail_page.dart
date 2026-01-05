// // pet_detail_page.dart
// import 'package:flutter/material.dart';
// import 'package:pet_connect/features/user/home/adoption_form_page.dart';
// import 'package:pet_connect/utils/constant.dart';
// import 'package:pet_connect/utils/primaryButton.dart';
// import 'package:pet_connect/widgets/compatibility.dart';
// import 'package:pet_connect/widgets/pet_list.dart';

// class PetDetailPage extends StatelessWidget {
//   final Pet pet;
//   const PetDetailPage({super.key, required this.pet});

//   @override
//   Widget build(BuildContext context) {
//     // Dummy Data
//     final medicalInfo =
//         'Neutered/Spayed: Yes, Vaccinations: Up to date, Microchipped: Yes.';
//     final personality =
//         'Sparky is energetic and loves long walks. Needs an active owner.';

//     return Scaffold(
//       backgroundColor: kCardColor,
//       body: Stack(
//         children: [
//           // Background Image/Carousel
//           Column(
//             children: [
//               Image.asset(
//                 pet.imageUrl,
//                 height: 350,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   height: 350,
//                   width: double.infinity,
//                   color: Colors.grey[300],
//                   child: const Icon(
//                     Icons.pets,
//                     size: 100,
//                     color: kPrimaryColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // Pet Details Sheet
//           DraggableScrollableSheet(
//             initialChildSize: 0.6,
//             minChildSize: 0.6,
//             maxChildSize: 1.0,
//             builder: (context, scrollController) {
//               return Container(
//                 decoration: const BoxDecoration(
//                   color: kBackgroundColor,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//                   boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
//                 ),
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   padding: const EdgeInsets.all(25.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 5,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),

//                       // Name and Basic Info
//                       Text(
//                         pet.name,
//                         style: kHeadlineStyle.copyWith(fontSize: 32),
//                       ),
//                       Text(
//                         '${pet.breed} | ${pet.age} Years Old | ${pet.gender}',
//                         style: kBodyStyle.copyWith(
//                           color: kSecondaryTextColor,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       // --- Compatibility System Integration ---
//                       CompatibilityWidget(petName: pet.name),
//                       const SizedBox(height: 20),

//                       // --- Personality ---
//                       _buildSectionTitle('Personality'),
//                       Text(
//                         personality,
//                         style: kBodyStyle.copyWith(color: kSecondaryTextColor),
//                       ),
//                       const SizedBox(height: 20),

//                       // --- Medical Info ---
//                       _buildSectionTitle('Medical Record'),
//                       Text(
//                         medicalInfo,
//                         style: kBodyStyle.copyWith(color: kSecondaryTextColor),
//                       ),
//                       const SizedBox(height: 30),

//                       // --- Action Buttons (Using function) ---
//                       buildPrimaryButton(
//                         context: context,
//                         text: 'Apply to Adopt ${pet.name}',
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   AdoptionFormPage(petName: pet.name),
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       OutlinedButton.icon(
//                         icon: const Icon(Icons.phone, color: kPrimaryColor),
//                         label: Text(
//                           'Contact Shelter Directly',
//                           style: kBodyStyle.copyWith(color: kPrimaryColor),
//                         ),
//                         onPressed: () {
//                           /* Handle contact action */
//                         },
//                         style: OutlinedButton.styleFrom(
//                           minimumSize: const Size(double.infinity, 50),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           side: const BorderSide(
//                             color: kPrimaryColor,
//                             width: 2,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 50),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),

//           // Custom Back Button (over the image)
//           Positioned(
//             top: 40,
//             left: 15,
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Text(title, style: kTitleStyle.copyWith(color: kTextColor)),
//     );
//   }
// }
