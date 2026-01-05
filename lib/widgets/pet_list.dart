// // pet_list_widgets.dart
// import 'package:flutter/material.dart';
// import 'package:pet_connect/features/user/home/pet_detail_page.dart';
// import 'package:pet_connect/utils/constant.dart';

// // Dummy Pet Model
// class Pet {
//   final String id;
//   final String name;
//   final String breed;
//   final int age;
//   final String gender;
//   final String status;
//   final String imageUrl;

//   Pet({
//     required this.id,
//     required this.name,
//     required this.breed,
//     required this.age,
//     required this.gender,
//     required this.status,
//     required this.imageUrl,
//   });
// }

// List<Pet> dummyPets = [
//   Pet(
//     id: 'p1',
//     name: 'Sparky',
//     breed: 'Golden Retriever',
//     age: 3,
//     gender: 'Male',
//     status: 'Available',
//     imageUrl: 'assets/sparky.jpg',
//   ),
//   Pet(
//     id: 'p2',
//     name: 'Luna',
//     breed: 'Siamese Cat',
//     age: 1,
//     gender: 'Female',
//     status: 'On Hold',
//     imageUrl: 'assets/luna.jpg',
//   ),
//   Pet(
//     id: 'p3',
//     name: 'Max',
//     breed: 'Beagle',
//     age: 5,
//     gender: 'Male',
//     status: 'Available',
//     imageUrl: 'assets/max.jpg',
//   ),
//   Pet(
//     id: 'p4',
//     name: 'Nala',
//     breed: 'Domestic Shorthair',
//     age: 2,
//     gender: 'Female',
//     status: 'Adopted',
//     imageUrl: 'assets/nala.jpg',
//   ),
// ];

// class PetCardWidget extends StatelessWidget {
//   final Pet pet;
//   const PetCardWidget({super.key, required this.pet});

//   @override
//   Widget build(BuildContext context) {
//     Color statusColor;
//     switch (pet.status) {
//       case 'Available':
//         statusColor = kSuccessColor;
//         break;
//       case 'On Hold':
//         statusColor = kWarningColor;
//         break;
//       default:
//         statusColor = Colors.red;
//     }

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => PetDetailPage(pet: pet)),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: kCardColor,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 3,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Photo & Status Tag
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(15),
//                   ),
//                   child: Image.asset(
//                     pet.imageUrl,
//                     height: 140,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       height: 140,
//                       width: double.infinity,
//                       color: Colors.grey[300],
//                       child: const Icon(
//                         Icons.pets,
//                         size: 50,
//                         color: kPrimaryColor,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.9),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       pet.status,
//                       style: kBodyStyle.copyWith(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // Details
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(pet.name, style: kTitleStyle.copyWith(fontSize: 18)),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${pet.breed} • ${pet.age} yrs',
//                     style: kBodyStyle.copyWith(
//                       color: kSecondaryTextColor,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PetListWidget extends StatefulWidget {
//   final bool showFilters;
//   const PetListWidget({super.key, this.showFilters = false});

//   @override
//   State<PetListWidget> createState() => _PetListWidgetState();
// }

// class _PetListWidgetState extends State<PetListWidget> {
//   // Dummy filter states
//   String _selectedBreed = 'All';
//   String _selectedGender = 'All';
//   bool _isVaccinated = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (widget.showFilters) _buildFiltersRow(),

//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16.0,
//             mainAxisSpacing: 16.0,
//             childAspectRatio: 0.75,
//           ),
//           itemCount: dummyPets.length,
//           itemBuilder: (context, index) {
//             return PetCardWidget(pet: dummyPets[index]);
//           },
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }

//   Widget _buildFiltersRow() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: Row(
//         children: [
//           _buildFilterChip(
//             'Breed',
//             _selectedBreed,
//             (val) => setState(() => _selectedBreed = val),
//           ),
//           _buildFilterChip(
//             'Gender',
//             _selectedGender,
//             (val) => setState(() => _selectedGender = val),
//           ),
//           _buildToggleChip(
//             'Vaccinated',
//             _isVaccinated,
//             (val) => setState(() => _isVaccinated = val),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(
//     String label,
//     String currentValue,
//     Function(String) onChanged,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: ChoiceChip(
//         label: Text(
//           '$label: $currentValue',
//           style: kBodyStyle.copyWith(fontSize: 14),
//         ),
//         selected: currentValue != 'All',
//         backgroundColor: Colors.grey[200],
//         selectedColor: kPrimaryColor.withOpacity(0.2),
//         checkmarkColor: kPrimaryColor,
//         onSelected: (bool selected) {
//           onChanged(currentValue == 'All' ? 'Dog' : 'All');
//         },
//       ),
//     );
//   }

//   Widget _buildToggleChip(String label, bool value, Function(bool) onChanged) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: ChoiceChip(
//         label: Text(label, style: kBodyStyle.copyWith(fontSize: 14)),
//         selected: value,
//         backgroundColor: Colors.grey[200],
//         selectedColor: kPrimaryColor.withOpacity(0.2),
//         checkmarkColor: kPrimaryColor,
//         onSelected: onChanged,
//       ),
//     );
//   }
// }
