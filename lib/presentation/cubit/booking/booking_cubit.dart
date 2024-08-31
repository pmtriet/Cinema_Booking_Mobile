import 'package:cinemabooking/common/services/preference.dart';
import 'package:cinemabooking/datalayer/data_response/booking/roomstate_response.dart';
import 'package:cinemabooking/domain/data_request/schedule/schedule_request.dart';
import 'package:cinemabooking/domain/repo_interface/booking_repo_interface.dart';
import 'package:cinemabooking/presentation/cubit/auth/app_cubit.dart';
import 'package:cinemabooking/presentation/states/booking/booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingCubit extends Cubit<BookingState> {
  final IBookingRepository bookingRepository;

  BookingCubit({required this.bookingRepository})
      : super(BookingInitialState());

  Future<void> getListSeats(int scheduleId, String date) async {
    try {
      var scheduleRequestDto = ScheduleRequest(scheduleId: scheduleId);
      final roomStateResponse =
          await bookingRepository.getListSeats(scheduleRequestDto);

      if (roomStateResponse.status == RoomStateStatus.success) {
        emit(BookingSuccessState(
            roomName: roomStateResponse.roomName,
            listSeats: roomStateResponse.seats!));
      } else if (roomStateResponse.status == RoomStateStatus.unauthorized) {
        Preferences.deleteToken();
        AppAuthCubit().logout();
      } else {
        emit(BookingErrorState(errorMessage: "Failed to get list seats"));
      }
    } catch (e) {
      emit(BookingErrorState(
          errorMessage: "Failed to get movies: ${e.toString()}"));
    }
  }
}
