import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sugar_mate/features/presentation/views/signup/widget/terms_dialog.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/navigation_routes.dart';
import '../../widgets/app_dropdown.dart';
import '../../widgets/app_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _mobileController = TextEditingController();

  DateTime? _selectedDate;
  // String? _selectedUserType;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  List<DropdownMenuItem<String>> get _userTypeItems => [
        DropdownMenuItem(
          value: 'patient',
          child: Text(AppStrings.patient),
        ),
        DropdownMenuItem(
          value: 'professional',
          child: Text(AppStrings.professional),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
        title: Text(
          AppStrings.signUp,
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.appWhiteColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    // AppDropdown<String>(
                    //   value: _selectedUserType,
                    //   labelText: AppStrings.selectUserType,
                    //   items: _userTypeItems,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _selectedUserType = value;
                    //     });
                    //   },
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return AppStrings.pleaseSelectUserType;
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // const SizedBox(height: 16),
                    AppTextField(
                      controller: _nameController,
                      labelText: AppStrings.fullName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Date of Birth
                    AppTextField(
                      controller: TextEditingController(
                        text: _selectedDate == null
                            ? ''
                            : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      ),
                      labelText: AppStrings.dateOfBirth,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (_selectedDate == null) {
                          return AppStrings.pleaseEnterDateOfBirth;
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
                          return AppStrings.pleaseEnterMobileNumber;
                        }
                        if (value.length < 10) {
                          return AppStrings.invalidMobileNumber;
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
                          return AppStrings.pleaseEnterEmail;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      labelText: AppStrings.password,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterPassword;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _confirmPasswordController,
                      labelText: AppStrings.confirmPassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseConfirmPassword;
                        }
                        if (value != _passwordController.text) {
                          return AppStrings.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptedTerms = value ?? false;
                      });
                    },
                    activeColor: AppColors.primaryColor,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _showTermsDialog,
                      child: RichText(
                        text: TextSpan(
                          text: 'I accept the ',
                          style: TextStyle(color: AppColors.appBlackColor),
                          children: [
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_acceptedTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please accept the Terms and Conditions.'),
                          backgroundColor: AppColors.appRedColor,
                        ),
                      );
                      return;
                    }

                    if (_formKey.currentState!.validate() && _selectedDate != null) {
                      try {
                        // Show loading spinner
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        );

                        // Create user with email and password
                        UserCredential userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );

                        User? user = userCredential.user;

                        if (user != null) {
                          // Save additional user data to Firestore
                          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                            'uid': user.uid,
                            'full_name': _nameController.text.trim(),
                            'email': _emailController.text.trim(),
                            'mobile_number': _mobileController.text.trim(),
                            'date_of_birth': DateFormat('dd/MM/yyyy').format(_selectedDate!),
                            // 'user_type': _selectedUserType,
                            'created_at': FieldValue.serverTimestamp(),
                          });

                          Navigator.of(context).pop(); // Close the loading spinner

                          // Navigate to SplashScreen or Home
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.kHomeMainView,
                                (route) => false,
                          );

                        }
                      } on FirebaseAuthException catch (e) {
                        Navigator.of(context).pop(); // Close the loading spinner

                        String errorMessage = 'An error occurred. Please try again.';
                        if (e.code == 'email-already-in-use') {
                          errorMessage = 'Email is already registered.';
                        } else if (e.code == 'invalid-email') {
                          errorMessage = 'Invalid email address.';
                        } else if (e.code == 'weak-password') {
                          errorMessage = 'Password should be at least 6 characters.';
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            backgroundColor: AppColors.appRedColor,
                          ),
                        );
                      } catch (e) {
                        Navigator.of(context).pop(); // Close the loading spinner

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Unexpected error: $e'),
                            backgroundColor: AppColors.appRedColor,
                          ),
                        );
                      }
                    } else if (_selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppStrings.pleaseEnterDateOfBirth),
                          backgroundColor: AppColors.appRedColor,
                        ),
                      );
                    }
                  },



                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.appWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    AppStrings.signUp,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                ),
                child: Text(AppStrings.alreadyHaveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return TermsDialog();
      },
    );
  }

}
