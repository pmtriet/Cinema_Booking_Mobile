import 'package:cinemabooking/config/ui.dart';
import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  const AppButton(
      {super.key,
      required this.title,
      required this.onTextButtonPressed,
      this.enable=true
      }
  );
  final String title;
  final bool enable;
  final VoidCallback onTextButtonPressed;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onTextButtonPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: (widget.enable == false)
              ? Colors.grey
              : const Color(appColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(btnBorderRadius),
          ),
        ),
        child: Text(widget.title),
        
      ),
    );
  }
}
