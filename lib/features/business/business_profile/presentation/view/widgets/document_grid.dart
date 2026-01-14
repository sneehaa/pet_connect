import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class DocumentGrid extends StatelessWidget {
  final List<String> documents;
  final VoidCallback onAddDocument;
  final Function(String) onViewDocument;
  final bool isLoading;

  const DocumentGrid({
    super.key,
    required this.documents,
    required this.onAddDocument,
    required this.onViewDocument,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: documents.length + 1,
          itemBuilder: (context, index) {
            if (index == documents.length) {
              return _buildAddDocumentCard();
            }
            return GestureDetector(
              onTap: () => onViewDocument(documents[index]),
              child: _buildDocumentCard(documents[index], index + 1),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDocumentCard(String document, int index) {
    final fileName = document.split('/').last;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryOrange.withOpacity(0.1),
                  AppColors.primaryOrange.withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getDocumentIcon(document),
              color: AppColors.primaryOrange,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              fileName.length > 15
                  ? '${fileName.substring(0, 15)}...'
                  : fileName,
              style: AppStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap to view',
            style: AppStyles.small.copyWith(
              fontSize: 11,
              color: AppColors.textLightGrey,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDocumentIcon(String document) {
    final extension = document.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  Widget _buildAddDocumentCard() {
    return GestureDetector(
      onTap: isLoading ? null : onAddDocument,
      child: Container(
        decoration: BoxDecoration(
          color: isLoading ? AppColors.backgroundGrey : AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLoading
                ? AppColors.backgroundGrey
                : AppColors.primaryOrange.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: isLoading
              ? [
                  const CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                    strokeWidth: 2,
                  ),
                ]
              : [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: AppColors.primaryOrange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add Document',
                    style: AppStyles.body.copyWith(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return GestureDetector(
      onTap: isLoading ? null : onAddDocument,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.backgroundGrey, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_upload,
                color: AppColors.primaryOrange,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No documents yet',
              style: AppStyles.headline3.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to upload verification documents',
              style: AppStyles.small.copyWith(color: AppColors.textLightGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(12),
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
                      'Upload Documents',
                      style: AppStyles.button.copyWith(fontSize: 14),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
