import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/navigation_routes.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_dropdown.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

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
  String? _selectedUserType;

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
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.signUp),
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
                  color: AppColors.appWhiteColor,
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
                    AppDropdown<String>(
                      value: _selectedUserType,
                      labelText: AppStrings.selectUserType,
                      items: _userTypeItems,
                      onChanged: (value) {
                        setState(() {
                          _selectedUserType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseSelectUserType;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _selectedDate != null) {
                      // TODO: Implement signup logic
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.kSplashScreen);
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
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(AppStrings.signUp),
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
}
