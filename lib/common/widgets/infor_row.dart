import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String? label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: label != null
                ? Text(
                    label!,
                    style: const TextStyle(color: Colors.grey),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
