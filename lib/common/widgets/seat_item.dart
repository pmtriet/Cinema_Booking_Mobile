import 'package:cinemabooking/config/ui.dart';
import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';
import 'package:cinemabooking/presentation/pages/booking/seat_toast.dart';
import 'package:flutter/material.dart';

class SeatItem extends StatefulWidget {
  const SeatItem(
      {super.key,
      required this.seat,
      required this.onTap,
      required this.canSelected});
  final SeatResponse seat;
  final bool canSelected;
  final Function(SeatResponse seat) onTap;

  @override
  State<SeatItem> createState() => _SeatItemState();
}

class _SeatItemState extends State<SeatItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if ((widget.canSelected == false) &&
            (widget.seat.seatStatus == 0)
          ) {
          SeatToastManager().showToast();
        }
        if (widget.seat.seatStatus == 0 && widget.canSelected == true) {
          //available -> chosen
          setState(() {
            widget.seat.seatStatus = 2;
          });
        } else if (widget.seat.seatStatus == 2) {
          //chosen -> available
          setState(() {
            widget.seat.seatStatus = 0;
          });
        }
        widget.onTap(widget.seat);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: widget.seat.seatStatus == 0
                  ? const Color(appColor)
                  : (widget.seat.seatStatus == 1 ? Colors.grey : Colors.green),
              shape: BoxShape.circle,
              border: widget.seat.seatType == 1
                  ? Border.all(
                      color: Colors.yellow,
                      width: 2.0,
                    )
                  : null,
            ),
          ),
          Text(
            widget.seat.seatName,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          )
        ],
      ),
    );
  }
}
