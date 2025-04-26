import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import 'data/doctor.dart';

class DoctorDetails extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetails({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text(doctor.name),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.appWhiteColor,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Hero(
              tag: doctor.id,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(doctor.profileImageUrl),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              doctor.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              doctor.specialization,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text("${doctor.rating}", style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Text("• ${doctor.experience} years experience"),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("About",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      doctor.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(height: 32),
                    Row(
                      children: [
                        const Icon(Icons.email, color: AppColors.primaryColor),
                        const SizedBox(width: 10),
                        Text(doctor.email,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: AppColors.primaryColor),
                        const SizedBox(width: 10),
                        Text(doctor.phone,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: AppColors.primaryColor,
      //   onPressed: () {
      //     // Example action: Booking or contact
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Appointment feature coming soon!')),
      //     );
      //   },
      //   icon: const Icon(
      //     Icons.calendar_today,
      //     color: AppColors.appWhiteColor,
      //   ),
      //   label: const Text(
      //     "Book Appointment",
      //     style: TextStyle(
      //       fontSize: 14,
      //       fontWeight: FontWeight.bold,
      //       color: AppColors.appWhiteColor,
      //     ),
      //   ),
      // ),
    );
  }
}
