// adoption_form_page.dart
import 'package:flutter/material.dart';
import 'package:pet_connect/utils/constant.dart';


class AdoptionFormPage extends StatefulWidget {
  final String petName;
  const AdoptionFormPage({Key? key, required this.petName}) : super(key: key);

  @override
  State<AdoptionFormPage> createState() => _AdoptionFormPageState();
}

class _AdoptionFormPageState extends State<AdoptionFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Application for ${widget.petName} submitted! Check history for status.')),
        );
        Navigator.pop(context);
      }
    }
  }

  // Define the buildPrimaryButton function here or import it
  Widget buildPrimaryButton({required String text, required VoidCallback onPressed, bool isLoading = false, required BuildContext context}) {
    // Reusing the function from the global scope or defining it here
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 4,
        ),
        child: isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(text, style: kButtonStyle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text('Adopt ${widget.petName}', style: kHeadlineStyle.copyWith(fontSize: 24)),
        backgroundColor: kCardColor,
        iconTheme: const IconThemeData(color: kTextColor),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Details', style: kTitleStyle),
              const SizedBox(height: 15),
              _buildTextFormField('Full Name'),
              _buildTextFormField('Email Address', keyboardType: TextInputType.emailAddress),
              _buildTextFormField('Phone Number', keyboardType: TextInputType.phone),
              const SizedBox(height: 25),

              Text('Living Situation', style: kTitleStyle),
              const SizedBox(height: 15),
              _buildTextFormField('Type of Home (Apartment/House)'),
              _buildTextFormField('Do you have a yard?', helperText: 'Yes/No'),
              _buildTextFormField('Number of People in Household'),
              const SizedBox(height: 30),

              buildPrimaryButton(
                context: context,
                text: 'Submit Application',
                onPressed: _submitApplication,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, {int maxLines = 1, TextInputType keyboardType = TextInputType.text, String? helperText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: kBodyStyle,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: kBodyStyle.copyWith(color: kPrimaryColor),
          helperText: helperText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: kPrimaryColor, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required.';
          }
          return null;
        },
      ),
    );
  }
}