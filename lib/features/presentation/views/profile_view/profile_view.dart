import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../widgets/app_text_field.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _pickedImage;
  bool _isUploading = false;
  Uint8List? _imageBytes;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  DateTime? _birthday;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();

  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    print(user?.uid);
    print('user?.uid');
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();
    print('data ${data}');
    if (data != null) {
      final fullName = data['full_name']?.split(' ') ?? ['', ''];
      _fullNameController.text = fullName.first;
      // _lastNameController.text = fullName.length > 1 ? fullName.sublist(1).join(' ') : '';
      _emailController.text = data['email'] ?? '';
      _mobileController.text = data['mobile_number'] ?? '';
      _profileImageUrl = data['profile_image'];
      if (data['date_of_birth'] != null) {
        try {
          _birthday = DateFormat('dd/MM/yyyy').parse(data['date_of_birth']);
        } catch (_) {}
      }
      setState(() {});
      print(_fullNameController.text);
      print('asdfasdf');
      print(_profileImageUrl);
      _imageBytes = base64Decode(_profileImageUrl??"");
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    // _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.appWhiteColor,
              surface: AppColors.appWhiteColor,
              onSurface: AppColors.appBlackColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthday = picked;
      });
    }
  }

  void _editProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _pickedImage = File(pickedFile.path);
      _isUploading = true;
    });

    final File imageFile = File(pickedFile.path);

    try {
      final bytes = await _pickedImage!.readAsBytes();
      final base64String = base64Encode(bytes);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
        setState(() => _isUploading = false);
        return;
      }

      // Update Firestore with profile image
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'profile_image': base64String,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.profile),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.appWhiteColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile picture section
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageBytes != null
                          ? MemoryImage(_imageBytes!)
                          : const AssetImage('assets/images/default_profile.png'),
                      // Change this to your default image
                      backgroundColor: AppColors.appWhiteColor,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: InkWell(
                        onTap: _editProfilePicture,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primaryColor,
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Form fields
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AppTextField(
                      controller: _fullNameController,
                      labelText: AppStrings.firstName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                    // const SizedBox(height: 16),
                    // AppTextField(
                    //   controller: _lastNameController,
                    //   labelText: AppStrings.lastName,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter last name';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: TextEditingController(
                        text: _birthday == null
                            ? ''
                            : DateFormat('dd/MM/yyyy').format(_birthday!),
                      ),
                      labelText: AppStrings.dateOfBirth,
                      readOnly: true,
                      onTap: () => _selectBirthday(context),
                      validator: (value) {
                        if (_birthday == null) {
                          return 'Please select birthday';
                        }
                        return null;
                      },
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: AppColors.appGreyColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _mobileController,
                      labelText: AppStrings.mobileNumber,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter mobile number';
                        }
                        if (value.length < 10) {
                          return 'Invalid mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _emailController,
                      labelText: AppStrings.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_formKey.currentState!.validate()) {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;

                        // final fullName = '${_fullNameController.text} ${_lastNameController.text}';
                        final dob = _birthday != null ? DateFormat('dd/MM/yyyy').format(_birthday!) : null;

                        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                          // 'full_name': fullName,
                          'email': _emailController.text.trim(),
                          'mobile_number': _mobileController.text.trim(),
                          'date_of_birth': dob,
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Profile updated successfully!')),
                        );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile saved successfully!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.appWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




}


