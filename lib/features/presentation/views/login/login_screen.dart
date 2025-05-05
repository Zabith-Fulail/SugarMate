import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/navigation_routes.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _handleLogin() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //
  //     try {
  //       // Simulate login delay (replace with actual Firebase auth)
  //       await Future.delayed(const Duration(seconds: 2));
  //
  //       if (mounted) {
  //         Navigator.of(context).pushReplacementNamed(Routes.kHomeMainView);
  //       }
  //     } catch (e) {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(e.toString()),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //       }
  //     } finally {
  //       if (mounted) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     }
  //   }
  // }
  Future<void> _handleLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Firebase email/password login
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          // Navigate to home
          Navigator.of(context).pushReplacementNamed(Routes.kHomeMainView);
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Invalid email address.';
            break;
          case 'user-not-found':
            errorMessage = 'No user found for that email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          default:
            errorMessage = 'Login failed. Please try again.';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Something went wrong.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.login),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.appWhiteColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Welcome Text
                    Text(
                      AppStrings.welcomeBack,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      AppStrings.loginDescription,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.appGreyColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Login Form Container
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppTextField(
                            textInputAction: TextInputAction.next,
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
                            textInputAction: TextInputAction.done,
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
                          const SizedBox(height: 8),
                          // Forgot Password Button
                          TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password navigation
                              // Navigator.of(context)
                              //     .pushNamed(Routes.kForgotPassword);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: AppColors.primaryColor,
                            ),
                            child: Text(
                              AppStrings.forgotPassword,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: AppColors.appWhiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.appWhiteColor,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                AppStrings.login,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    // Sign Up Link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.kSignupScreen);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                        ),
                        child: Text(AppStrings.dontHaveAccount),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
