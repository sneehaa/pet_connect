// adoption_status_widget.dart
import 'package:flutter/material.dart';
import 'package:pet_connect/utils/constant.dart';


class AdoptionApplication {
  final String petName;
  final DateTime dateSubmitted;
  final String status;

  AdoptionApplication({required this.petName, required this.dateSubmitted, required this.status});
}

class AdoptionStatusWidget extends StatelessWidget {
  final AdoptionApplication application;
  const AdoptionStatusWidget({Key? key, required this.application}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (application.status) {
      case 'Approved':
        statusColor = kSuccessColor;
        statusIcon = Icons.check_circle;
        break;
      case 'In Review':
        statusColor = kInfoColor;
        statusIcon = Icons.visibility;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'Pending':
      default:
        statusColor = kWarningColor;
        statusIcon = Icons.hourglass_empty;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor, size: 30),
        title: Text(
          application.petName,
          style: kTitleStyle.copyWith(fontSize: 18),
        ),
        subtitle: Text(
          'Status: ${application.status}\nSubmitted: ${application.dateSubmitted.month}/${application.dateSubmitted.day}/${application.dateSubmitted.year}',
          style: kBodyStyle.copyWith(fontSize: 14, color: kSecondaryTextColor),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: kSecondaryTextColor),
        isThreeLine: true,
        onTap: () {
          // Navigate to a detailed status page
        },
      ),
    );
  }
}