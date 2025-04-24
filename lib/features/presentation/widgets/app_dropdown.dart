import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const AppDropdown({
    Key? key,
    required this.value,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: AppColors.appGreyColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
      dropdownColor: AppColors.appWhiteColor,
      style: TextStyle(
        color: AppColors.appBlackColor,
        fontSize: 16,
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: AppColors.appGreyColor,
      ),
    );
  }
}
