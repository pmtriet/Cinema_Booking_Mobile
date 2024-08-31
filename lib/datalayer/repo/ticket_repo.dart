import 'package:cinemabooking/common/services/preference.dart';
import 'package:cinemabooking/config/sever_url.dart';
import 'package:cinemabooking/datalayer/services/payment_api.dart';
import 'package:cinemabooking/domain/data_request/booking/booking_request.dart';
import 'package:cinemabooking/domain/repo_interface/ticket_repo_interface.dart';

class TicketPageRepository implements ITicketRepository {
  final PaymentApi ticketApi = PaymentApi();

  @override
  Future<int> payment(BookingRequest bookingRequestDto) async {
    String? token = await Preferences
        .getToken(); //-1: error token, 0: unsuccess, 1: success
    //String token ="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NywiZW1haWwiOiJhZG1pbkBnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3MjIzNDkwMDgsImV4cCI6MTcyMjM1MjYwOH0.X6VukZy_F6TgPH9KWEBHc2KMOc6kDUu8pXW9Wfmb500";
    if (token != null) {
      try {
        final response = await ticketApi.payment(
          baseUrl: serverUrl,
          path: "/booking",
          token: token,
          data: bookingRequestDto.toJson(),
        );
        if (response.statusCode == 200) {
          return 1;
        }
        return 0;
      } catch (e) {
        return 0;
      }
    }
    return -1;
  }
}
