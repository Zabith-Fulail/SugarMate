import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/app_colors.dart';
import 'data/doctor.dart';

class DoctorDetails extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetails({super.key, required this.doctor});
  List<Map<String, String>> extractHospitalNameAndCity(List<String> hospitals) {
    return hospitals
        .where((h) => h.trim().isNotEmpty)
        .map((h) {
      final namePart = h.split('(')[0].trim(); // remove anything in parentheses
      final parts = h.split(',');
      final city = parts.isNotEmpty ? parts.last.trim() : '';
      return {
        'name': namePart,
        'city': city,
      };
    })
        .toList();
  }
  List<String> extractValidChannelingLinks(List<String> links) {
    return links.where((link) => link.trim().isNotEmpty).toList();
  }

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
              tag: doctor.name,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: Image.network(
                    doctor.image,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 60);
                    },
                  ),
                ),
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
            const SizedBox(height: 20),
            (doctor.mobile.isNotEmpty || doctor.email.isNotEmpty) ? Card(
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
                      doctor.experience.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(height: 32),
                    if(doctor.email.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.email, color: AppColors.primaryColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              doctor.email,
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.fade, // or TextOverflow.ellipsis
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    if(doctor.mobile.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: AppColors.primaryColor),
                              const SizedBox(width: 10),
                              Text(doctor.mobile,
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      )

                  ],
                ),
              ),
            ) : Center(
              child: Text(
                "No contact information available",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            if (doctor.hospitals.any((h) => h.trim().isNotEmpty)) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Hospitals",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: extractHospitalNameAndCity(doctor.hospitals)
                    .map((hospital) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      const Icon(Icons.local_hospital, size: 20, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "${hospital['name']} - ${hospital['city']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ))
                    .toList(),
              ),
            ],
            // if (doctor.chanellingCentres.any((c) => c.trim().isNotEmpty)) ...[
            //   const SizedBox(height: 20),
            //   const Text("Channeling Centers",
            //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            //   const SizedBox(height: 8),
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: extractValidChannelingLinks(doctor.chanellingCentres)
            //         .asMap()
            //         .entries
            //         .map((entry) {
            //       final index = entry.key + 1;
            //       final url = entry.value;
            //       return Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 6.0),
            //         child: Row(
            //           children: [
            //             const Icon(Icons.link, size: 20, color: Colors.blue),
            //             const SizedBox(width: 10),
            //             Expanded(
            //               child: InkWell(
            //                 onTap: () => launchLink(url),
            //                 child: Text(
            //                   'Channeling Center $index',
            //                   style: const TextStyle(
            //                     fontSize: 16,
            //                     color: Colors.blue,
            //                     decoration: TextDecoration.underline,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     })
            //         .toList(),
            //   ),
            // ],


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
  Future<void> launchLink(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

}
