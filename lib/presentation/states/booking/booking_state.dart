import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';

abstract class BookingState {}

class BookingInitialState extends BookingState {}

class BookingLoadingState extends BookingState {}

class BookingSuccessState extends BookingState {
  final List<SeatResponse> listSeats;
  final String roomName;

  BookingSuccessState({required this.listSeats, required this.roomName});
}

class BookingErrorState extends BookingState {
  final String errorMessage;

  BookingErrorState({required this.errorMessage});
}
