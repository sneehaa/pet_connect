import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/business/business_auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:pet_connect/features/business/business_auth/presentation/state/auth_state.dart';
import 'package:pet_connect/features/business/business_auth/presentation/view/login_view.dart';

class UploadBusinessDocument extends ConsumerStatefulWidget {
  const UploadBusinessDocument({super.key});

  @override
  ConsumerState<UploadBusinessDocument> createState() =>
      _UploadBusinessDocumentState();
}

class _UploadBusinessDocumentState
    extends ConsumerState<UploadBusinessDocument> {
  final List<PlatformFile> _selectedFiles = [];

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files);
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _uploadDocuments() {
    final paths = _selectedFiles.map((file) => file.path!).toList();

    ref.read(businessViewModelProvider.notifier).uploadDocuments(paths);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessViewModelProvider);

    ref.listen<BusinessState>(businessViewModelProvider, (previous, next) {
      if (previous?.isLoading == true &&
          next.isLoading == false &&
          next.message != null) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess: !next.isError,
        );
      }

      if (previous?.isLoading == true &&
          next.isLoading == false &&
          !next.isError &&
          next.flow == BusinessFlow.documentsUploaded) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const BusinessLoginScreen()),
              (_) => false,
            );
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Documents'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Upload Card
            GestureDetector(
              onTap: _pickFiles,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.upload_file, size: 50),
                    SizedBox(height: 12),
                    Text(
                      'Tap to upload documents',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text('PDF, JPG, PNG', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Selected Files
            Expanded(
              child: ListView.builder(
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  final file = _selectedFiles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.insert_drive_file),
                      title: Text(file.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _removeFile(index),
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Upload Button
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: state.isLoading || _selectedFiles.isEmpty
                    ? null
                    : _uploadDocuments,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  minimumSize: const Size(200, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: state.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Upload Documents',
                        style: GoogleFonts.alice(
                          fontSize: 20,
                          color: AppColors.primaryWhite,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
