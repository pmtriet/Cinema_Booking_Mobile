import 'package:cinemabooking/common/widgets/button.dart';
import 'package:cinemabooking/common/widgets/infor_row.dart';
import 'package:cinemabooking/config/route.dart';
import 'package:cinemabooking/config/ui.dart';
import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';
import 'package:cinemabooking/datalayer/repo/schedule_repo.dart';
import 'package:cinemabooking/presentation/cubit/payment/payment_cubit.dart';
import 'package:cinemabooking/presentation/states/payment/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage(
      {super.key,
      required this.chosenSeats,
      required this.scheduleId,
      required this.roomName});
  final List<SeatResponse> chosenSeats;
  final int scheduleId;
  final String roomName;
  @override
  Widget build(BuildContext context) {
    final paymentRepository = ScheduleRepository();
    return BlocProvider(
      create: (_) => PaymentCubit(scheduleRepository: paymentRepository),
      child: MaterialApp(
        home: PaymentView(
          chosenSeats: chosenSeats,
          scheduleId: scheduleId,
          roomName: roomName,
        ),
      ),
    );
  }
}

class PaymentView extends StatelessWidget {
  const PaymentView(
      {super.key,
      required this.chosenSeats,
      required this.scheduleId,
      required this.roomName});
  final List<SeatResponse> chosenSeats;
  final int scheduleId;
  final String roomName;

  String stringListSeat(List<SeatResponse> seats) {
    String string = "";
    for (var i = 0; i < seats.length; i++) {
      string += seats[i].seatName;
      if (i != seats.length - 1) {
        string += ",";
      }
    }
    return string;
  }

  int getTotalPrice(List<SeatResponse> seats) {
    int totalPrice = 0;
    for (var seat in seats) {
      totalPrice += seat.seatPrice;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Pay for tickets',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(backgroundColor),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(appColor),
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          backgroundColor: const Color(backgroundColor),
          body: BlocBuilder<PaymentCubit, PaymentState>(
            builder: (context, state) {
              switch (state){
                case PaymentLoadingState():
                  context.read<PaymentCubit>().getScheduleById(scheduleId);
                  return const Center(child: CircularProgressIndicator());
                case PaymentSuccessState():
                  int cost = getTotalPrice(chosenSeats);
                  String strListSeat = stringListSeat(chosenSeats);
                  return _paymentWidget(context, roomName, state.movieName,
                    state.scheduleDateTime, cost, strListSeat);
                case PaymentErrorState():
                  return _errorWidget(state.errorMessage);
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }

  Widget _paymentWidget(BuildContext context, String roomName, String movieName,
      String scheduleDateTime, int cost, String stringListSeat) {
    List<String> listValue =
        context.read<PaymentCubit>().groupSeatNames(chosenSeats);
    List<int> seatIds = chosenSeats.map((seat) => seat.seatId).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movieName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            InfoRow(label: 'Room', value: roomName),
            InfoRow(label: 'Date', value: scheduleDateTime),
            InfoRow(label: 'Cost', value: cost.toString()),
            Column(
              children: List.generate(listValue.length, (index) {
                return InfoRow(
                  label: index == 0 ? 'Seats' : null,
                  value: listValue[index],
                );
              }),
            ),
            const SizedBox(
              height: 30,
            ),
            AppButton(
              title: "Continue",
              onTextButtonPressed: () {
                // String dataQr =
                //     'Movie:$movieName-Room:$roomName-Datetime:$scheduleDateTime-Seats:$stringListSeat';
                // context.push(
                //   '${RouteName.ticket}/${Uri.encodeComponent(dataQr)}',
                //   extra: {
                //     'chosenSeats': chosenSeats,
                //     'scheduleId': scheduleId,
                //     'roomName':roomName,
                //     'movieName':movieName,
                //     'dateTime':scheduleDateTime,
                //     'cost':cost.toString(),
                //     'nameChosenSeats':listValue,
                //   },
                // );
                context.push(RouteName.ticket, extra: {
                   'chosenSeats': seatIds,
                   'scheduleId': scheduleId,
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorWidget(String? errorMessage) {
    return Center(
      child: Text(
        errorMessage ?? 'Something went wrong',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
