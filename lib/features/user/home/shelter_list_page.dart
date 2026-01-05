
// import 'package:flutter/material.dart';
// import 'package:pet_connect/features/user/home/shelter_detail_page.dart';
// import 'package:pet_connect/utils/constant.dart';


// class Shelter {
//   final String id;
//   final String name;
//   final String location;
//   final String imageUrl;
//   final int petCount;
//   Shelter({required this.id, required this.name, required this.location, required this.imageUrl, required this.petCount});
// }

// List<Shelter> dummyShelters = [
//   Shelter(id: '1', name: 'Kind Heart Rescue', location: 'New York, NY', imageUrl: 'assets/shelter1.jpg', petCount: 45),
//   Shelter(id: '2', name: 'Paws & Whiskers', location: 'San Francisco, CA', imageUrl: 'assets/shelter2.jpg', petCount: 32),
//   Shelter(id: '3', name: 'City Animal Care', location: 'Boston, MA', imageUrl: 'assets/shelter3.jpg', petCount: 68),
// ];

// class ShelterListPage extends StatefulWidget {
//   const ShelterListPage({Key? key}) : super(key: key);

//   @override
//   State<ShelterListPage> createState() => _ShelterListPageState();
// }

// class _ShelterListPageState extends State<ShelterListPage> {
//   String _currentLocationFilter = 'New York, NY'; // Default location

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackgroundColor,
//       appBar: AppBar(
//         title: Text('Shelters Near You', style: kHeadlineStyle.copyWith(fontSize: 24)),
//         backgroundColor: kCardColor,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: kTextColor),
//       ),
//       body: Column(
//         children: [
//           // Location Filter Dropdown
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(color: Colors.grey.shade300),
//                 color: kCardColor,
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: _currentLocationFilter,
//                   isExpanded: true,
//                   icon: const Icon(Icons.keyboard_arrow_down, color: kPrimaryColor),
//                   style: kBodyStyle.copyWith(fontSize: 16),
//                   items: <String>['New York, NY', 'San Francisco, CA', 'Boston, MA', 'Dallas, TX']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _currentLocationFilter = newValue!;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ),
          
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//               itemCount: dummyShelters.length,
//               itemBuilder: (context, index) {
//                 final shelter = dummyShelters[index];
//                 return _ShelterCard(shelter: shelter);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Widget for a single shelter item
// class _ShelterCard extends StatelessWidget {
//   final Shelter shelter;
//   const _ShelterCard({Key? key, required this.shelter}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ShelterDetailPage(shelter: shelter)),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 20),
//         decoration: BoxDecoration(
//           color: kCardColor,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Image
//             ClipRRect(
//               borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
//               child: Image.asset(
//                 shelter.imageUrl,
//                 width: 100,
//                 height: 100,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   width: 100, height: 100, color: Colors.grey[300],
//                   child: const Icon(Icons.apartment, color: kPrimaryColor, size: 40),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 15),
//             // Details
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(shelter.name, style: kTitleStyle.copyWith(fontSize: 18)),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, size: 16, color: kSecondaryTextColor),
//                         const SizedBox(width: 4),
//                         Text(shelter.location, style: kBodyStyle.copyWith(color: kSecondaryTextColor, fontSize: 14)),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text('${shelter.petCount} pets',
//                         style: kBodyStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
//                   ],
//                 ),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.only(right: 15.0),
//               child: Icon(Icons.arrow_forward_ios, size: 16, color: kSecondaryTextColor),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }