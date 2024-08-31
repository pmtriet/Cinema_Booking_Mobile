abstract class TicketPageState {}

class TicketPageInitialState extends TicketPageState {}

class TicketPageLoadingState extends TicketPageState {}

class PaymentPageTicketState extends TicketPageState {}

class TicketPageErrorState extends TicketPageState{
  final String errorMessage;
  TicketPageErrorState(this.errorMessage);
}
