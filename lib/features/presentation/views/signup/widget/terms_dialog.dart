import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';

class TermsDialog extends StatelessWidget {
  const TermsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: AppColors.appWhiteColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Divider(color: AppColors.appGreyColor.withValues(alpha: 0.3)),
            const SizedBox(height: 12),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'By signing up, you agree to our Terms and Conditions. '
                  'Please read these carefully. You must not misuse our services... '
                  'This agreement governs your use of the application. The app '
                  'reserves the right to modify the terms at any time. Please '
                  'review regularly. Continued use of the app constitutes acceptance.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.appBlackColor,
                    height: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Accept Button
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Got it',
                  style: TextStyle(
                    color: AppColors.appWhiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
