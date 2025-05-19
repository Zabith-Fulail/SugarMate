// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../../../../utils/app_colors.dart';
//
// class DoctorSuggestionView extends StatefulWidget {
//   const DoctorSuggestionView({super.key});
//
//   @override
//   State<DoctorSuggestionView> createState() => _DoctorSuggestionViewState();
// }
//
// class _DoctorSuggestionViewState extends State<DoctorSuggestionView> {
//   late GoogleMapController mapController;
//   final List<LatLng> staticLocations = [
//     LatLng(6.869571362245269, 79.92640675040384),
//     LatLng(6.890001794855813, 79.87566658465792),
//     LatLng(6.87869033868979, 79.93525301534206),
//     LatLng(6.920501658713063, 79.85388446931586),
//     LatLng(6.920639358672688, 79.86573526931586),
//     LatLng(6.920337012141919, 79.85374734048034),
//     LatLng(6.9206819613330195, 79.86586401534207),
//     LatLng(6.922958209842572, 79.86590573068412),
//     LatLng(6.991171432299349, 79.93838124417758),
//     LatLng(6.902310370536264, 79.85357901534206),
//   ];
//   LatLng? userLocation;
//   LatLng? doctorHospitalLocation;
//
//   final String hospitalUrl = 'https://maps.app.goo.gl/3RL53aqgSmweJyvf8?g_st=com.google.maps.preview.copy';
//   final String doctorName = "Dr. Uditha Bulugahapitiya";
//
//   @override
//   void initState() {
//     super.initState();
//     _initLocations();
//   }
//
//   Future<void> _initLocations() async {
//     try {
//       Position position = await getCurrentLocation();
//       LatLng? hospitalCoords = await getCoordinatesFromUrl(hospitalUrl);
//
//       if (hospitalCoords == null) {
//         throw Exception("Failed to extract hospital coordinates.");
//       }
//
//       setState(() {
//         userLocation = LatLng(position.latitude, position.longitude);
//         doctorHospitalLocation = hospitalCoords;
//       });
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   Future<Position> getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) throw Exception("Location services are disabled.");
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception("Location permissions are denied.");
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception("Location permissions are permanently denied.");
//     }
//
//     return await Geolocator.getCurrentPosition();
//   }
//
//   Future<LatLng?> getCoordinatesFromUrl(String url) async {
//     // Placeholder: Replace with actual parsing or geocoding
//     // This is hardcoded for Nawaloka Hospital (Colombo 02)
//     return LatLng(6.927079, 79.861244);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (userLocation == null || doctorHospitalLocation == null) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: AppColors.appWhiteColor),
//         backgroundColor: AppColors.primaryColor,
//         foregroundColor: AppColors.appWhiteColor,
//         title: const Text(" Nearby Doctor Suggestion"),
//         centerTitle: true,
//         titleTextStyle: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: AppColors.appWhiteColor,
//         ),
//       ),
//       body: Container(
//         margin: EdgeInsets.all(16),
//         height: 400,
//         decoration: BoxDecoration(
//           border: Border.all(color: AppColors.primaryColor, width: 2),
//
//         ),
//         width: double.maxFinite,
//         child: GoogleMap(
//           myLocationEnabled: true,
//           zoomControlsEnabled: false,
//           onMapCreated: (controller) => mapController = controller,
//           initialCameraPosition: CameraPosition(
//             target: userLocation!,
//             zoom: 13,
//           ),
//           markers: {
//             Marker(
//               markerId: const MarkerId("user"),
//               position: userLocation!,
//               infoWindow: const InfoWindow(title: "You"),
//               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//             ),
//             Marker(
//               markerId: const MarkerId("doctor"),
//               position: doctorHospitalLocation!,
//               infoWindow: InfoWindow(title: doctorName),
//             ),
//           },
//         ),
//       ),
//     );
//   }
// }
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import 'data/doctor.dart';

class DoctorSuggestionView extends StatefulWidget {
  const DoctorSuggestionView({super.key});

  @override
  State<DoctorSuggestionView> createState() => _DoctorSuggestionViewState();
}

class _DoctorSuggestionViewState extends State<DoctorSuggestionView> {
  Doctor? doctor;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('doctors').get();
      final doctorList = snapshot.docs.map((doc) => Doctor.fromFirestore(doc.data())).toList();

      if (doctorList.isNotEmpty) {
        final randomDoctor = doctorList[Random().nextInt(doctorList.length)];
        setState(() {
          doctor = randomDoctor;
        });
      }
    } catch (e) {
      print("Error fetching doctors: $e");
    }
  }

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

  @override
  Widget build(BuildContext context) {
    if (doctor == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text(doctor!.name),
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
              tag: doctor!.name,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: Image.network(
                    doctor!.image,
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
              doctor!.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              doctor!.specialization,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            (doctor!.mobile.isNotEmpty || doctor!.email.isNotEmpty)
                ? Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text("About",
                    //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    // const SizedBox(height: 8),
                    // Text(
                    //   "${doctor!.experience} years of experience",
                    //   style: const TextStyle(fontSize: 16),
                    // ),
                    // const Divider(height: 32),
                    if (doctor!.email.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.email, color: AppColors.primaryColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              doctor!.email,
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    if (doctor!.mobile.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: AppColors.primaryColor),
                              const SizedBox(width: 10),
                              Text(doctor!.mobile, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      )
                  ],
                ),
              ),
            )
                : Center(
              child: Text(
                "No contact information available",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ),
            if (doctor!.hospitals.any((h) => h.trim().isNotEmpty)) ...[
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Hospitals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: extractHospitalNameAndCity(doctor!.hospitals)
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
          ],
        ),
      ),
    );
  }
}