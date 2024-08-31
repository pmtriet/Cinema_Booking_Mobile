import 'package:cinemabooking/common/services/preference.dart';
import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';
import 'package:cinemabooking/domain/data_request/booking/booking_request.dart';
import 'package:cinemabooking/domain/repo_interface/ticket_repo_interface.dart';
import 'package:cinemabooking/presentation/cubit/auth/app_cubit.dart';
import 'package:cinemabooking/presentation/states/ticket/ticket_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketPageCubit extends Cubit<TicketPageState> {
  final ITicketRepository ticketRepository;

  TicketPageCubit({required this.ticketRepository})
      : super(TicketPageInitialState());

  Future<void> loading(int scheduleId, List<SeatResponse> chosenSeats) async {
    emit(TicketPageLoadingState());
    await Future.delayed(const Duration(seconds: 5));

    payment(scheduleId,chosenSeats);
  }
  Future<void> payment(int scheduleId, List<SeatResponse> chosenSeats) async {
    try {
      final bookingRequestDto =
          BookingRequest(scheduleId: scheduleId, chosenSeats: chosenSeats);
      final paymentSuccess = await ticketRepository.payment(bookingRequestDto);
      if (paymentSuccess == 1) {
        emit(PaymentPageTicketState());
      } else if (paymentSuccess == -1) {
        Preferences.deleteToken();
        AppAuthCubit().logout();
      } else {
        emit(TicketPageErrorState('Fail to payment'));
      }
    } catch (e) {
      emit(TicketPageErrorState("Failed to payment: ${e.toString()}"));
    }
  }
}
