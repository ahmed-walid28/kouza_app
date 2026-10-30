import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CustomSoilTextField extends StatelessWidget {
  final String label;
  final String? helper;
  final String? unit;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final double? minValue;
  final double? maxValue;

  const CustomSoilTextField({
    super.key,
    required this.label,
    required this.controller,
    this.helper,
    this.unit,
    this.prefixIcon,
    this.minValue,
    this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          fontFamily: 'Saudi',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          filled: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Saudi',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
          helperText: helper,
          helperStyle: TextStyle(
            fontFamily: 'Saudi',
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.primary, size: 22)
              : null,
          suffixText: unit,
          suffixStyle: const TextStyle(
            fontFamily: 'Saudi',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال $label';
          }
          final number = double.tryParse(value.trim());
          if (number == null) {
            return 'يرجى إدخال رقم صحيح أو عشري';
          }
          if (minValue != null && number < minValue!) {
            return 'القيمة لا يمكن أن تقل عن $minValue';
          }
          if (maxValue != null && number > maxValue!) {
            return 'القيمة لا يمكن أن تزيد عن $maxValue';
          }
          return null;
        },
      ),
    );
  }
}
