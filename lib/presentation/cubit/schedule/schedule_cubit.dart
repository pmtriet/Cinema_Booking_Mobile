import 'package:cinemabooking/datalayer/data_response/schedule/schedule.dart';
import 'package:cinemabooking/datalayer/data_response/schedule/schedule_room_response.dart';
import 'package:cinemabooking/domain/data_request/schedule/schedule_movieid_day_request.dart';
import 'package:cinemabooking/domain/repo_interface/schedule_repo_interface.dart';
import 'package:cinemabooking/presentation/states/schedule/schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final IScheduleRepository scheduleRepository;

  ScheduleCubit({required this.scheduleRepository})
      : super(ScheduleLoadingState());

  Future<void> getSchedulesByMoviesIdFollowDay(int movieId, String day) async {
    try {
      var convertedDay="$day 00:00:00";
      var scheduleRequestDTO =
          ScheduleRequestByMovieIdFollowDay(movieId: movieId, day: convertedDay);
      final result = await scheduleRepository
          .getSchedulesByMovieIdFollowDay(scheduleRequestDTO);
      if (result != null) {
        Map<int, Map<String, List<Schedule>>> schedulesByRoomId =
            groupSchedulesByRoomId(result);
        emit(ScheduleSuccessState(schedules: schedulesByRoomId));
      } else {
        emit(ScheduleErrorState('Nothing to show'));
      }
    } catch (e) {
      emit(ScheduleErrorState("Failed to get schedule: ${e.toString()}"));
    }
  }
}

Map<int, Map<String, List<Schedule>>> groupSchedulesByRoomId(
    List<ScheduleRoomResponse> scheduleResponseList) {
  Map<int, Map<String, List<Schedule>>> schedulesByRoomId = {};

  for (var scheduleResponse in scheduleResponseList) {
    var schedule = Schedule(
      scheduleId: scheduleResponse.scheduleId,
      startTime: scheduleResponse.startTime,
      endTime: scheduleResponse.endTime,
    );

    if (schedulesByRoomId.containsKey(scheduleResponse.roomId) == false) {
      schedulesByRoomId[scheduleResponse.roomId] = {
        scheduleResponse.roomName: []
      };
    }
    schedulesByRoomId[scheduleResponse.roomId]![scheduleResponse.roomName]!
        .add(schedule);
  }

  for (var roomId in schedulesByRoomId.keys) {
    for (var roomName in schedulesByRoomId[roomId]!.keys) {
      schedulesByRoomId[roomId]![roomName]!.sort((a, b) => a.startTime.compareTo(b.startTime));
    }
  }

  return schedulesByRoomId;
}
