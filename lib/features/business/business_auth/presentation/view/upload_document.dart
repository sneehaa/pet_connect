import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
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

  @override
  void initState() {
    super.initState();
    // Reset state when entering this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(businessViewModelProvider.notifier).reset();
    });
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      final newFiles = result.files
          .where(
            (newFile) => !_selectedFiles.any(
              (existingFile) => existingFile.path == newFile.path,
            ),
          )
          .toList();

      setState(() {
        _selectedFiles.addAll(newFiles);
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _uploadDocuments() {
    if (_selectedFiles.isEmpty) return;

    final paths = _selectedFiles.map((file) => file.path!).toList();
    ref.read(businessViewModelProvider.notifier).uploadDocuments(paths);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to state changes - same pattern as login screen
    ref.listen<BusinessState>(businessViewModelProvider, (previous, next) {
      if (next.message != null) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess: !next.isError,
        );

        // Navigate to login on successful document upload
        if (!next.isError && next.flow == BusinessFlow.documentsUploaded) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const BusinessLoginScreen()),
                (route) => false,
              );
            }
          });
        }

        // Reset state after showing message
        ref.read(businessViewModelProvider.notifier).reset();
      }
    });

    final state = ref.watch(businessViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Business Verification',
          style: AppStyles.headline3.copyWith(color: Colors.black87),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Upload Documents',
                  style: AppStyles.headline3.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 4),
                Text(
                  'Required to activate your business account for review.',
                  style: AppStyles.subtitle.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.left,
                ),

                const SizedBox(height: 30),

                // Upload Area (Drop Zone Style)
                GestureDetector(
                  onTap: state.isLoading ? null : _pickFiles,
                  child: BusinessUploadArea(
                    primaryColor: AppColors.primaryOrange,
                  ),
                ),

                const SizedBox(height: 24),

                // Files Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected Files (${_selectedFiles.length})',
                      style: AppStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_selectedFiles.isNotEmpty && !state.isLoading)
                      TextButton(
                        onPressed: () => setState(() => _selectedFiles.clear()),
                        child: Text(
                          'Clear All',
                          style: AppStyles.small.copyWith(
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // File List
                Expanded(
                  child: _selectedFiles.isEmpty
                      ? Center(
                          child: Text(
                            'No files selected. Tap the area above to begin.',
                            style: AppStyles.small.copyWith(color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: _selectedFiles.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final file = _selectedFiles[index];
                            return FileListItem(
                              file: file,
                              onRemove: state.isLoading
                                  ? () {}
                                  : () => _removeFile(index),
                              primaryColor: AppColors.primaryOrange,
                            );
                          },
                        ),
                ),

                const SizedBox(height: 20),

                // Continue Button
                state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _selectedFiles.isEmpty
                              ? null
                              : _uploadDocuments,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                            disabledBackgroundColor: AppColors.primaryOrange
                                .withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            'Continue',
                            style: AppStyles.button.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Full screen loading overlay (optional)
          if (state.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(32),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Uploading ${_selectedFiles.length} document${_selectedFiles.length > 1 ? "s" : ""}...',
                          style: AppStyles.body,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BusinessUploadArea extends StatelessWidget {
  final Color primaryColor;

  const BusinessUploadArea({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryColor.withOpacity(0.5),
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.drive_folder_upload_rounded,
            size: 64,
            color: primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Tap to Select Files',
            style: AppStyles.headline3.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Maximum 5MB per file (PDF, JPG, PNG)',
            style: AppStyles.small.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class FileListItem extends StatelessWidget {
  final PlatformFile file;
  final VoidCallback onRemove;
  final Color primaryColor;

  const FileListItem({
    super.key,
    required this.file,
    required this.onRemove,
    required this.primaryColor,
  });

  String get _fileSize {
    if (file.size >= 1048576) {
      return '${(file.size / 1048576).toStringAsFixed(1)} MB';
    } else {
      return '${(file.size / 1024).toStringAsFixed(1)} KB';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPdf = file.extension == 'pdf';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          isPdf ? Icons.picture_as_pdf_outlined : Icons.insert_photo_outlined,
          color: primaryColor,
          size: 28,
        ),
        title: Text(
          file.name,
          style: AppStyles.body.copyWith(fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${file.extension?.toUpperCase() ?? 'FILE'} • $_fileSize',
          style: AppStyles.small.copyWith(color: Colors.grey.shade500),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 20,
            color: Colors.grey.shade500,
          ),
          onPressed: onRemove,
          tooltip: 'Remove file',
        ),
      ),
    );
  }
}
