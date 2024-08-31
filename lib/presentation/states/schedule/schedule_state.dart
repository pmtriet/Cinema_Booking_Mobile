import 'package:cinemabooking/datalayer/data_response/schedule/schedule.dart';

abstract class ScheduleState {} 

class ScheduleInitialState extends ScheduleState {}

class ScheduleLoadingState extends ScheduleState {}

class ScheduleSuccessState extends ScheduleState {
  final Map<int, Map<String, List<Schedule>>> schedules;

  ScheduleSuccessState({required this.schedules});
}

class ScheduleErrorState extends ScheduleState {
  final String errorMessage;
  ScheduleErrorState(this.errorMessage);
}