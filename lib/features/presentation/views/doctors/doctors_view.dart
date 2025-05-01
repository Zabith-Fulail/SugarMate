import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sugar_mate/utils/app_strings.dart';

import '../../../../utils/app_colors.dart';
import 'data/doctor.dart';
import 'doctor_details.dart';

class DoctorsView extends StatefulWidget {
  const DoctorsView({super.key});

  @override
  State<DoctorsView> createState() => _DoctorsViewState();
}

class _DoctorsViewState extends State<DoctorsView> {
  List<Doctor> allDoctors = [];
  List<Doctor> filteredDoctors = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  void _filterDoctors(String query) {
    setState(() {
      searchQuery = query;
      filteredDoctors = allDoctors.where((doctor) {
        return doctor.name.toLowerCase().contains(query.toLowerCase()) ||
            doctor.specialization.toLowerCase().contains(query.toLowerCase());
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
                  child: TextField(
                    onChanged: _filterDoctors,
                    decoration: InputDecoration(
                      hintText: 'Search by name or specialization...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
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
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.person);
                                },
                              ),
                            ),
                          ),
                          title: Text(doctor.name),
                          subtitle: Text(
                              '${doctor.specialization} • ${doctor.experience} yrs exp'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 20),
                              Text(doctor.rating.toString()),
                            ],
                          ),
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
        rating: (data['rating'] ?? 0).toDouble(),
      );
    }).toList();

    return doctors;
  }

  void loadDoctors() async {
    setState(() => isLoading = true);
    allDoctors = await fetchDoctorsFromFirestore();
    filteredDoctors = List.from(allDoctors);
    setState(() => isLoading = false);
  }
}
