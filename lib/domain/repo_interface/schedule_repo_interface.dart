import 'package:cinemabooking/datalayer/data_response/schedule/schedule_room_response.dart';
import 'package:cinemabooking/datalayer/data_response/schedule/schedule_movie_response.dart';
import 'package:cinemabooking/domain/data_request/schedule/schedule_request.dart';
import 'package:cinemabooking/domain/data_request/schedule/schedule_movieid_day_request.dart';

abstract class IScheduleRepository {
  Future<List<ScheduleRoomResponse>?> getSchedulesByMovieIdFollowDay(
      ScheduleRequestByMovieIdFollowDay scheduleRequestDTO);

  Future<ScheduleMovieResponse?> getSchedulesById(
      ScheduleRequest scheduleRequestDTO);
}
