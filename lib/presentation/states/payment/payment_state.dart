abstract class PaymentState {} 

class PaymentLoadingState extends PaymentState {}

class PaymentSuccessState extends PaymentState {
  final String scheduleDateTime;
  final String movieName;

  PaymentSuccessState({required this.scheduleDateTime,required this.movieName});
}

class PaymentErrorState extends PaymentState {
  final String errorMessage;
  PaymentErrorState(this.errorMessage);
}