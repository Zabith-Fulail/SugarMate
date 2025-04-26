import 'package:flutter/material.dart';
import 'package:sugar_mate/utils/app_strings.dart';
import '../../../../utils/app_colors.dart';
import 'data/doctor.dart';
import 'doctor_details.dart';  // Make sure to import the DoctorDetails page

class DoctorsView extends StatefulWidget {
  const DoctorsView({super.key});

  @override
  State<DoctorsView> createState() => _DoctorsViewState();
}

class _DoctorsViewState extends State<DoctorsView> {
  List<Doctor> allDoctors = [
    Doctor(
      id: '1',
      name: 'Dr. John Smith',
      specialization: 'Cardiologist',
      experience: 10,
      rating: 4.5,
      profileImageUrl: 'https://randomuser.me/api/portraits/men/10.jpg',
      description: 'Experienced cardiologist with 10 years of expertise in heart-related treatments and surgeries.',
      email: 'john.smith@example.com',
      phone: '+1 555 123 4567',
    ),
    Doctor(
      id: '2',
      name: 'Dr. Jane Doe',
      specialization: 'Dentist',
      experience: 8,
      rating: 4.2,
      profileImageUrl: 'https://randomuser.me/api/portraits/women/20.jpg',
      description: 'Friendly dentist specializing in cosmetic and pediatric dentistry, ensuring a perfect smile.',
      email: 'jane.doe@example.com',
      phone: '+1 555 987 6543',
    ),
    Doctor(
      id: '3',
      name: 'Dr. William Brown',
      specialization: 'Dermatologist',
      experience: 6,
      rating: 4.0,
      profileImageUrl: 'https://randomuser.me/api/portraits/men/30.jpg',
      description: 'Expert dermatologist focused on treating skin conditions with a holistic approach.',
      email: 'william.brown@example.com',
      phone: '+1 555 345 6789',
    ),
    Doctor(
      id: '4',
      name: 'Dr. Emily Johnson',
      specialization: 'Neurologist',
      experience: 12,
      rating: 4.8,
      profileImageUrl: 'https://randomuser.me/api/portraits/women/40.jpg',
      description: 'Senior neurologist specializing in brain and nervous system disorders with over 12 years experience.',
      email: 'emily.johnson@example.com',
      phone: '+1 555 456 7890',
    ),
    Doctor(
      id: '5',
      name: 'Dr. Michael Davis',
      specialization: 'Pediatrician',
      experience: 5,
      rating: 4.1,
      profileImageUrl: 'https://randomuser.me/api/portraits/men/50.jpg',
      description: 'Caring pediatrician providing excellent healthcare to children of all ages.',
      email: 'michael.davis@example.com',
      phone: '+1 555 678 1234',
    ),
  ];

  List<Doctor> filteredDoctors = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredDoctors = List.from(allDoctors); // show all at first
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
      body: Column(
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
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(doctor.name),
                    subtitle: Text('${doctor.specialization} • ${doctor.experience} yrs exp'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        Text(doctor.rating.toString()),
                      ],
                    ),
                    onTap: () {
                      // Navigate to the doctor details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetails(doctor: doctor),
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
}
