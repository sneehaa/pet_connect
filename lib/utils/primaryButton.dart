// Reusable function to build the primary button
import 'package:flutter/material.dart';
import 'package:pet_connect/utils/constant.dart';

Widget buildPrimaryButton({
  required String text,
  required VoidCallback onPressed,
  bool isLoading = false,
  required BuildContext context,
}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Matching your search bar style
        ),
        elevation: 4,
        padding: EdgeInsets.zero, // Remove default padding
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: kButtonStyle,
            ),
    ),
  );
}