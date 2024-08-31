import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';

enum RoomStateStatus { success, unauthorized, error }

class RoomStateResponse {
  final RoomStateStatus status;
  final String roomName;
  final List<SeatResponse>? seats;

  RoomStateResponse({required this.status,required this.roomName, this.seats});
}
