import 'package:cinemabooking/config/sever_url.dart';
import 'package:cinemabooking/datalayer/data_response/schedule/schedule_room_response.dart';
import 'package:cinemabooking/datalayer/data_response/schedule/schedule_movie_response.dart';
import 'package:cinemabooking/datalayer/services/schedule_api.dart';
import 'package:cinemabooking/domain/data_request/schedule/schedule_request.dart';
import 'package:cinemabooking/domain/data_request/schedule/schedule_movieid_day_request.dart';
import 'package:cinemabooking/domain/repo_interface/schedule_repo_interface.dart';

class ScheduleRepository implements IScheduleRepository {
  final ScheduleApi scheduleApi = ScheduleApi();

  @override
  Future<List<ScheduleRoomResponse>?> getSchedulesByMovieIdFollowDay(
      ScheduleRequestByMovieIdFollowDay scheduleRequestDTO) async {
    try {
      final response = await scheduleApi.getScheduleByIdFollowDay(
        baseUrl: serverUrl,
        path: "/movie/getMovieFollowDay",
        data: scheduleRequestDTO.toJson(),
      );
      if (response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        var dataList = responseData['data'] as List;
        if (dataList.isNotEmpty) {
          for (var i in dataList) {
            var movieId = i["id"] as int;
            if (movieId == scheduleRequestDTO.movieId) {
              var scheduleList = dataList[0]['schedule'] as List;
              if (scheduleList.isNotEmpty) {
                List<ScheduleRoomResponse> list = [];
                for (var json in scheduleList) {    
                  var i = ScheduleRoomResponse(
                    scheduleId: json['id'] as int,
                    startTime: json['timeStart'] as String,
                    endTime: json['timeEnd'] as String,
                    roomId: 1,
                    roomName: "01",
                  );           
                  //list.add(ScheduleRoomResponse.fromJson(json));
                  list.add(i);
                }
                return list;
              }
            }
          }
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<ScheduleMovieResponse?> getSchedulesById(
      ScheduleRequest scheduleRequestDTO) async {
    try {
      final response = await scheduleApi.getScheduleById(
        baseUrl: serverUrl,
        path: "/schedule/getScheduleId/${scheduleRequestDTO.scheduleId}",
      );
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        var data = responseData['data'] as Map<String, dynamic>;
        var schedule = ScheduleMovieResponse.fromJson(data);
        return schedule;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
