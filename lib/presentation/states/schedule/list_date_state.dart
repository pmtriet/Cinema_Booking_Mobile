import 'package:cinemabooking/domain/data_request/schedule/date.dart';

abstract class ListDateState {} 

class ListDateInitialState extends ListDateState {}

class ListDateLoadingState extends ListDateState {}

class ListDateSuccessState extends ListDateState {
  final List<DateItem> listDatetime;

  ListDateSuccessState({required this.listDatetime});
}

class ListDateErrorState extends ListDateState {
  final String errorMessage;
  ListDateErrorState(this.errorMessage);
}