import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';

class BookingRequest {
  final int scheduleId;
  List<SeatResponse> chosenSeats;
  BookingRequest({required this.scheduleId, required this.chosenSeats});

  Map<String, dynamic> toJson() => {
        'scheduleId': scheduleId,
        'seatIds': chosenSeats.map((seat) => seat.seatId).toList(),
      };
}
