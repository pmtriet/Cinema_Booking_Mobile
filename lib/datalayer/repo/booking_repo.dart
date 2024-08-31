import 'package:cinemabooking/common/services/preference.dart';
import 'package:cinemabooking/config/sever_url.dart';
import 'package:cinemabooking/datalayer/data_response/booking/roomstate_response.dart';
import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';
import 'package:cinemabooking/datalayer/services/booking_api.dart';
import 'package:cinemabooking/domain/data_request/schedule/schedule_request.dart';
import 'package:cinemabooking/domain/repo_interface/booking_repo_interface.dart';

class BookingRepository implements IBookingRepository {
  final BookingApi bookingApi = BookingApi();

  @override
  Future<RoomStateResponse> getListSeats(
      ScheduleRequest bookingRequestDto) async {
    String? token = await Preferences.getToken();
    //String token ="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NywiZW1haWwiOiJhZG1pbkBnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3MjIzNDkwMDgsImV4cCI6MTcyMjM1MjYwOH0.X6VukZy_F6TgPH9KWEBHc2KMOc6kDUu8pXW9Wfmb500";
    if (token != null) {
      final response = await bookingApi.getListSeats(
        baseUrl: serverUrl,
        path: "/room-state/${bookingRequestDto.scheduleId}",
        token: token,
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>;

        final roomResponse = data['room'] as Map<String, dynamic>;
        final roomNameResponse = roomResponse['roomName'] as String;

        final availableSeatsJson = data['seats'] as List<dynamic>;
        final listSeats = availableSeatsJson
            .map((seatJson) =>
                SeatResponse.fromJson(seatJson, bookingRequestDto.scheduleId))
            .toList();
        return RoomStateResponse(
            status: RoomStateStatus.success,
            roomName: roomNameResponse,
            seats: listSeats);
      }
      return RoomStateResponse(
          status: RoomStateStatus.error, 
          roomName: "", 
          seats: null
      );
    }
    return RoomStateResponse(
        status: RoomStateStatus.unauthorized, 
        roomName: "", 
        seats: null
    );
  }
}
