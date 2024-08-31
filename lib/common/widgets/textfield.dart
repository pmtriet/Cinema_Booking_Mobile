import 'package:cinemabooking/config/ui.dart';
import 'package:flutter/material.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.icon,
    this.isPassword,
    this.errorText,
    required this.onTap
  });
  final String labelText;
  final Icon icon;
  final TextEditingController controller;
  final String? errorText;
  final bool? isPassword;
  final Function() onTap;
  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: (widget.isPassword != null && widget.isPassword!)
          ? obscureText
          : false,
      decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Color(textColor)),
          prefixIcon: widget.icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(textFieldBorderRadius),
            borderSide: const BorderSide(width: 1.5, color: Color(appColor)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(textFieldBorderRadius),
            borderSide: const BorderSide(width: 1.5, color: Color(appColor)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(textFieldBorderRadius),
            borderSide: const BorderSide(width: 1.5, color: Color(appColor)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(textFieldBorderRadius),
            borderSide: const BorderSide(width: 1.5, color: Color(appColor)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(textFieldBorderRadius),
            borderSide: const BorderSide(
                width: 1.5, color: Color.fromARGB(255, 228, 140, 89)),
          ),
          fillColor: Colors.transparent,
          errorText: widget.errorText,
          errorMaxLines: 2),
      style: const TextStyle(color: Color(textFieldColor)),
      onTap: widget.onTap,
    );
  }
}
