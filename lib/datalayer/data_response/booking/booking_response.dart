import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';

class BookingResponse {
  final String roomName;
  final String date;
  final String time;
  final List<SeatResponse> seats;

  BookingResponse(
      {required this.roomName,
      required this.date,
      required this.time,
      required this.seats});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      roomName: json['name'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      seats: json['seats'] as List<SeatResponse>,
    );
  }
}
