import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sugar_mate/utils/app_strings.dart';

import '../../../../utils/app_colors.dart';
import 'data/doctor.dart';
import 'doctor_details.dart';

class DoctorsListView extends StatefulWidget {
  const DoctorsListView({super.key});

  @override
  State<DoctorsListView> createState() => _DoctorsListViewState();
}

class _DoctorsListViewState extends State<DoctorsListView> {
  List<Doctor> allDoctors = [];
  List<Doctor> filteredDoctors = [];
  String searchQuery = '';
  bool isLoading = true;
  List<String> allCities = [];
  String? selectedCity;
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
    LatLng(6.878743596732853, 79.93519937116447),
    LatLng(6.9206720693810775, 79.85392738465794),
    LatLng(6.920767166642167, 79.86574599815138),
    LatLng(6.920422217513343, 79.85384389999999),
    LatLng(6.920767166642167, 79.86577818465793),
    LatLng(6.923054065351969, 79.86581989999998),
    LatLng(6.991192730431039, 79.93833832883551),
    LatLng(6.8898526758579, 79.87568804232896),
    LatLng(6.920576213387881, 79.85394884232896),
    LatLng(6.920422217513343, 79.85380098465792),
    LatLng(6.920416453355977, 79.85400248650656),
    LatLng(6.912692064395926, 79.87032705767105),
    LatLng(6.893426417920866, 79.87436205582131),
    LatLng(6.902289068378626, 79.85356828650654),
  ];




  // Set<Marker> _getCityMarkers() {
  //   final markers = <Marker>{};
  //
  //   // Existing doctor-based markers
  //   for (var doctor in filteredDoctors) {
  //     for (var hospital in doctor.hospitals) {
  //       final city = _extractCity(hospital);
  //       final latLng = cityCoordinates[city];
  //       if ((selectedCity == null || selectedCity == city) && latLng != null) {
  //         markers.add(
  //           Marker(
  //             markerId: MarkerId('$city-${doctor.name}'),
  //             position: latLng,
  //             infoWindow: InfoWindow(title: doctor.name),
  //           ),
  //         );
  //       }
  //     }
  //   }
  //
  //   // New: Static coordinate markers
  //   for (int i = 0; i < staticLocations.length; i++) {
  //     markers.add(
  //       Marker(
  //         markerId: MarkerId('static-$i'),
  //         position: staticLocations[i],
  //         infoWindow: InfoWindow(title: 'Location ${i + 1}'),
  //       ),
  //     );
  //   }
  //
  //   return markers;
  // }

  Set<Marker> _getCityMarkers() {
    final markers = <Marker>{};

    int requiredMarkers = filteredDoctors.length * 3;
    int count = 0;

    for (int i = 0; i < staticLocations.length && count < requiredMarkers; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('static-$i'),
          position: staticLocations[i],
          infoWindow: InfoWindow(title: 'Doctor Location ${count + 1}'),
        ),
      );
      count++;
    }

    return markers;
  }


  // Helper: Extract city from hospital string
  String _extractCity(String hospital) {
    // Assumes city is after last comma
    final parts = hospital.split(',');
    if (parts.isNotEmpty) {
      return parts.last.trim();
    }
    return '';
  }

  // Build list of unique cities from all doctors
  void _buildCityList() {
    final citiesSet = <String>{};
    for (var doc in allDoctors) {
      for (var hospital in doc.hospitals) {
        final city = _extractCity(hospital);
        if (city.isNotEmpty) {
          citiesSet.add(city);
        }
      }
    }
    allCities = citiesSet.toList();
    allCities.sort();
  }

  // Filter doctors by selected city
  void _filterDoctorsByCity(String? city) {
    setState(() {
      selectedCity = city;
      if (city == null || city.isEmpty) {
        filteredDoctors = List.from(allDoctors);
      } else {
        filteredDoctors = allDoctors.where((doctor) {
          return doctor.hospitals.any((hospital) {
            final cityInHospital = _extractCity(hospital);
            return cityInHospital == city;
          });
        }).toList();
      }
    });
  }
  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  void _filterDoctors(String query) {
    setState(() {
      searchQuery = query;
      filteredDoctors = allDoctors.where((doctor) {
        return doctor.name.toLowerCase().contains(query.toLowerCase())
            // ||
            // doctor.specialization.toLowerCase().contains(query.toLowerCase())
        ;
      }).toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.doctors),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.appWhiteColor,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Filter by City',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: selectedCity,
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text('All Cities'),
                ),
                ...allCities.map((city) => DropdownMenuItem(
                  value: city,
                  child: Text(city),
                )),
              ],
              onChanged: (value) {
                _filterDoctorsByCity(value == '' ? null : value);
              },
            ),
          ),
          SizedBox(
            height: 200,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _getCityLatLng(selectedCity),
                zoom: 12,
              ),
              markers: _getCityMarkers(),
              onMapCreated: (GoogleMapController controller) {
                // You can store the controller if needed
              },
            ),
          ),
          SizedBox(height: 24,),
          Expanded(
            child: filteredDoctors.isEmpty
                ? Center(child: Text('No doctors found in selected city'))
                : ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(
                        child: Image.network(
                          doctor.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          loadingBuilder:
                              (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person);
                          },
                        ),
                      ),
                    ),
                    title: Text(doctor.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DoctorDetails(doctor: doctor),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(AppStrings.doctors),
  //       titleTextStyle: const TextStyle(
  //         fontSize: 20,
  //         fontWeight: FontWeight.bold,
  //         color: AppColors.appWhiteColor,
  //       ),
  //       iconTheme: const IconThemeData(
  //         color: AppColors.appWhiteColor,
  //       ),
  //       centerTitle: true,
  //       backgroundColor: AppColors.primaryColor,
  //     ),
  //     body: isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: TextField(
  //                   onChanged: _filterDoctors,
  //                   decoration: InputDecoration(
  //                     hintText: 'Search by name or specialization...',
  //                     prefixIcon: const Icon(Icons.search),
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemCount: filteredDoctors.length,
  //                   itemBuilder: (context, index) {
  //                     final doctor = filteredDoctors[index];
  //                     return Card(
  //                       margin: const EdgeInsets.symmetric(
  //                           horizontal: 16, vertical: 8),
  //                       child: ListTile(
  //                         leading: CircleAvatar(
  //                           backgroundColor: Colors.grey[200],
  //                           child: ClipOval(
  //                             child: Image.network(
  //                               doctor.image,
  //                               width: 50,
  //                               height: 50,
  //                               fit: BoxFit.cover,
  //                               loadingBuilder:
  //                                   (context, child, loadingProgress) {
  //                                 if (loadingProgress == null) return child;
  //                                 return const SizedBox(
  //                                   width: 24,
  //                                   height: 24,
  //                                   child: CircularProgressIndicator(
  //                                       strokeWidth: 2),
  //                                 );
  //                               },
  //                               errorBuilder: (context, error, stackTrace) {
  //                                 return const Icon(Icons.person);
  //                               },
  //                             ),
  //                           ),
  //                         ),
  //                         title: Text(doctor.name),
  //                         // subtitle: Text(
  //                         //     '${doctor.specialization} • ${doctor.experience} yrs exp'),
  //                         onTap: () {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) =>
  //                                   DoctorDetails(doctor: doctor),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //   );
  // }

  Future<List<Doctor>> fetchDoctorsFromFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference doctorCollection =
        firestore.collection('doctors');

    final QuerySnapshot snapshot = await doctorCollection.get();

    List<Doctor> doctors = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return Doctor(
        name: data['name'] ?? '',
        specialization: data['specialization'] ?? '',
        qualifications: data['qualifications'] ?? '',
        email: data['email'] ?? '',
        mobile: data['mobile'] ?? '',
        hospitals: List<String>.from(data['hospitals'] ?? []),
        chanellingCentres: List<String>.from(data['chanellingCentres'] ?? []),
        image: data['image'] ?? '',
        experience: data['experience'] ?? 0,
      );
    }).toList();

    return doctors;
  }

  void loadDoctors() async {
    setState(() => isLoading = true);
    allDoctors = await fetchDoctorsFromFirestore();
    _buildCityList();
    filteredDoctors = List.from(allDoctors);
    setState(() => isLoading = false);
    print(allDoctors[0].toString());
  }
  Map<String, LatLng> cityCoordinates = {
    'Colombo': LatLng(6.9271, 79.8612),
    'Kandy': LatLng(7.2906, 80.6337),
    'Galle': LatLng(6.0535, 80.2210),
    'Nugegoda': LatLng(6.8721, 79.8880),
    'Sri Jayewardenepura': LatLng(6.9023, 79.8613),
    // Add more as needed
  };
  LatLng _getCityLatLng(String? city) {
    if (city != null && cityCoordinates.containsKey(city)) {
      return cityCoordinates[city]!;
    }
    return const LatLng(6.9271, 79.8612); // Default to Colombo
  }
  // Set<Marker> _getCityMarkers() {
  //   final markers = <Marker>{};
  //
  //   for (var doctor in filteredDoctors) {
  //     for (var hospital in doctor.hospitals) {
  //       final city = _extractCity(hospital);
  //       if (selectedCity == null || selectedCity == city) {
  //         final latLng = cityCoordinates[city];
  //         if (latLng != null) {
  //           markers.add(
  //             Marker(
  //               markerId: MarkerId('$city-${doctor.name}'),
  //               position: latLng,
  //               infoWindow: InfoWindow(title: doctor.name),
  //             ),
  //           );
  //         }
  //       }
  //     }
  //   }
  //
  //   return markers;
  // }

}
