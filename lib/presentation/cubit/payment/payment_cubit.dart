import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';
import 'package:cinemabooking/domain/data_request/schedule/schedule_request.dart';
import 'package:cinemabooking/domain/repo_interface/schedule_repo_interface.dart';
import 'package:cinemabooking/presentation/states/payment/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final IScheduleRepository scheduleRepository;

  PaymentCubit({required this.scheduleRepository})
      : super(PaymentLoadingState());

  Future<void> getScheduleById(int scheduleId) async {
    try {
      var scheduleRequestDto = ScheduleRequest(scheduleId: scheduleId);
      final schedule =
          await scheduleRepository.getSchedulesById(scheduleRequestDto);

      if (schedule != null) {
        var dateTime = '${schedule.date}, ${schedule.startTime}';
        var movieName = schedule.movieName;
        emit(PaymentSuccessState(
            scheduleDateTime: dateTime, movieName: movieName));
      } else {
        emit(PaymentErrorState('Fail to get seats'));
      }
    } catch (e) {
      emit(PaymentErrorState("Failed to get movies: ${e.toString()}"));
    }
  }

  List<String> groupSeatNames(List<SeatResponse> chosenSeats) {
    List<String> list = [];
    String value = "";

    for (var index = 0; index < chosenSeats.length; index++) {
      if (index % 5 == 0 && value.isNotEmpty) {
        list.add(value.trim());
        value = "";
      }
      value += '${chosenSeats[index].seatName} ';
    }

    if (value.isNotEmpty) {
      list.add(value.trim());
    }

    return list;
  }
}
