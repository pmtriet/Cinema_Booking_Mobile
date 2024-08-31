import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChosenSeatsCubit extends Cubit<List<SeatResponse>> {
  ChosenSeatsCubit() : super([]);

  void addSeat(SeatResponse seat) {
    final currentState = List<SeatResponse>.from(state);
    currentState.add(seat);
    emit(currentState);
  }

  void removeSeat(SeatResponse seat) {
    final currentState = List<SeatResponse>.from(state);
    currentState.remove(seat);
    emit(currentState);
  }

  void clearSeats() {
    emit([]);
  }
}
