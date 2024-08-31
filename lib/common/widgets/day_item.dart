import 'package:cinemabooking/config/ui.dart';
import 'package:cinemabooking/domain/data_request/schedule/date.dart';
import 'package:flutter/material.dart';

class DayItemWidget extends StatefulWidget {
  const DayItemWidget({super.key, required this.item, required this.onTap});
  final DateItem item;
  final Function(String fullDay) onTap;

  @override
  State<DayItemWidget> createState() => _DayItemWidgetState();
}

class _DayItemWidgetState extends State<DayItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.item.shortDay,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () {
            setState(() {
              widget.item.isSelected = true;
            });
            
            widget.onTap(widget.item.fullDay);
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor:
                widget.item.isSelected ? const Color(appColor) : Colors.black,
            child: Text(
              widget.item.displayDate,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
