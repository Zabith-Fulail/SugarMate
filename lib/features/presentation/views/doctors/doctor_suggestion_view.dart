import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../utils/app_colors.dart';

class DoctorSuggestionView extends StatefulWidget {
  const DoctorSuggestionView({super.key});

  @override
  State<DoctorSuggestionView> createState() => _DoctorSuggestionViewState();
}

class _DoctorSuggestionViewState extends State<DoctorSuggestionView> {
  late GoogleMapController mapController;
  final List<LatLng> staticLocations = [
    LatLng(6.869571362245269, 79.92640675040384),
    LatLng(6.890001794855813, 79.87566658465792),
    LatLng(6.87869033868979, 79.93525301534206),
    LatLng(6.920501658713063, 79.85388446931586),
    LatLng(6.920639358672688, 79.86573526931586),
    LatLng(6.920337012141919, 79.85374734048034),
    LatLng(6.9206819613330195, 79.86586401534207),
    LatLng(6.922958209842572, 79.86590573068412),
    LatLng(6.991171432299349, 79.93838124417758),
    LatLng(6.902310370536264, 79.85357901534206),
  ];
  LatLng? userLocation;
  LatLng? doctorHospitalLocation;

  final String hospitalUrl = 'https://maps.app.goo.gl/3RL53aqgSmweJyvf8?g_st=com.google.maps.preview.copy';
  final String doctorName = "Dr. Uditha Bulugahapitiya";

  @override
  void initState() {
    super.initState();
    _initLocations();
  }

  Future<void> _initLocations() async {
    try {
      Position position = await getCurrentLocation();
      LatLng? hospitalCoords = await getCoordinatesFromUrl(hospitalUrl);

      if (hospitalCoords == null) {
        throw Exception("Failed to extract hospital coordinates.");
      }

      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
        doctorHospitalLocation = hospitalCoords;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Location services are disabled.");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied.");
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<LatLng?> getCoordinatesFromUrl(String url) async {
    // Placeholder: Replace with actual parsing or geocoding
    // This is hardcoded for Nawaloka Hospital (Colombo 02)
    return LatLng(6.927079, 79.861244);
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == null || doctorHospitalLocation == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.appWhiteColor),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.appWhiteColor,
        title: const Text(" Nearby Doctor Suggestion"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor, width: 2),

        ),
        width: double.maxFinite,
        child: GoogleMap(
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: (controller) => mapController = controller,
          initialCameraPosition: CameraPosition(
            target: userLocation!,
            zoom: 13,
          ),
          markers: {
            Marker(
              markerId: const MarkerId("user"),
              position: userLocation!,
              infoWindow: const InfoWindow(title: "You"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            ),
            Marker(
              markerId: const MarkerId("doctor"),
              position: doctorHospitalLocation!,
              infoWindow: InfoWindow(title: doctorName),
            ),
          },
        ),
      ),
    );
  }
}
