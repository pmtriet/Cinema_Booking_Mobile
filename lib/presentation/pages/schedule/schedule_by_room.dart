import 'package:cinemabooking/datalayer/data_response/schedule/schedule.dart';
import 'package:flutter/material.dart';

class ScheduleItemRowsWidget extends StatelessWidget {
  final String roomName;
  final List<Schedule> listSchedule;
  final Function(int scheduleId,String startTime) onTap;

  const ScheduleItemRowsWidget(
      {super.key,
      required this.roomName,
      required this.listSchedule,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xff637394)),
          bottom: BorderSide(color: Color(0xff637394)),
        ),
      ),
      child: Row(
        children: [
          const Text(
            //'Room $roomName',
            'Showtime',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: listSchedule.map((schedule) {
                  return GestureDetector(
                    onTap: () {
                      onTap(schedule.scheduleId,schedule.startTime);                      
                    },
                    child: Row(
                      children: [
                        const VerticalDivider(
                          color: Color(0xff637394),
                          thickness: 1,
                          width: 20,
                        ),
                        Text(
                          '${schedule.startTime}-${schedule.endTime}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
