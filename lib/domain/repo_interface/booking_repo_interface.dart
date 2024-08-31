import 'package:cinemabooking/datalayer/data_response/booking/roomstate_response.dart';
import 'package:cinemabooking/domain/data_request/schedule/schedule_request.dart';

abstract class IBookingRepository {
  Future<RoomStateResponse> getListSeats(
      ScheduleRequest seatByScheduleIdRequestDto);
}
