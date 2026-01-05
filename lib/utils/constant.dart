import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const Color kPrimaryColor = Color(0xFFFF987C);
const Color kBackgroundColor = Colors.white; 
const Color kCardColor = Colors.white;
const Color kTextColor = Colors.black; 
const Color kSecondaryTextColor = Color.fromARGB(
  255,
  114,
  113,
  113,
); 
const Color kSuccessColor = Color(0xFF4CAF50);
const Color kWarningColor = Color(0xFFFFC107);
const Color kInfoColor = Color(0xFF2196F3);

TextStyle kHeadlineStyle = GoogleFonts.alice(
  fontSize: 26,
  fontWeight: FontWeight.bold,
  color: kTextColor,
);

TextStyle kTitleStyle = GoogleFonts.alice(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: kTextColor,
);

TextStyle kBodyStyle = GoogleFonts.alice(fontSize: 16, color: kTextColor);

TextStyle kButtonStyle = GoogleFonts.alice(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
