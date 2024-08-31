import 'package:cinemabooking/domain/data_request/booking/booking_request.dart';

abstract class ITicketRepository {
  Future<int> payment(BookingRequest bookingRequestDto);
}
