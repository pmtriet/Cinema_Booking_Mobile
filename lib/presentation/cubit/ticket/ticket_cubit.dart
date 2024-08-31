import 'package:cinemabooking/presentation/states/ticket/ticket_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketCubit extends Cubit<TicketState> {

  TicketCubit(): super(TicketHideState());

  Future<void> showTicket() async {
    emit(TicketShowState());
  }

  Future<void> hideTicket() async {
    emit(TicketHideState());
  }
}
