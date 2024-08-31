import 'package:cinemabooking/common/widgets/infor_row.dart';
import 'package:cinemabooking/config/route.dart';
import 'package:cinemabooking/config/ui.dart';
import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';
import 'package:cinemabooking/datalayer/repo/ticket_repo.dart';
import 'package:cinemabooking/presentation/cubit/ticket/ticket_cubit.dart';
import 'package:cinemabooking/presentation/cubit/ticket/ticket_page_cubit.dart';
import 'package:cinemabooking/presentation/pages/ticket/qr_generator.dart';
import 'package:cinemabooking/presentation/states/ticket/ticket_page_state.dart';
import 'package:cinemabooking/presentation/states/ticket/ticket_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class TicketPage extends StatelessWidget {
  const TicketPage(
      {super.key,
      required this.dataQr,
      required this.scheduleId,
      required this.chosenSeats,
      required this.roomName,
      required this.movieName,
      required this.dateTime,
      required this.cost,
      required this.nameChosenSeats});
  final String dataQr;
  final int scheduleId;
  final List<SeatResponse> chosenSeats;
  final List<String> nameChosenSeats;

  final String roomName;
  final String movieName;
  final String dateTime;
  final String cost;

  @override
  Widget build(BuildContext context) {
    final ticketRepository = TicketPageRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TicketPageCubit(ticketRepository: ticketRepository),
        ),
        BlocProvider(
          create: (context) => TicketCubit(),
        )
      ],
      child: MaterialApp(
        home: TicketView(
          dataQr: dataQr,
          chosenSeats: chosenSeats,
          scheduleId: scheduleId,
          roomName: roomName,
          movieName: movieName,
          dateTime: dateTime,
          cost: cost,
          nameChosenSeats: nameChosenSeats,
        ),
      ),
    );
  }
}

class TicketView extends StatefulWidget {
  const TicketView(
      {super.key,
      required this.dataQr,
      required this.scheduleId,
      required this.chosenSeats,
      required this.roomName,
      required this.movieName,
      required this.dateTime,
      required this.cost,
      required this.nameChosenSeats});
  final String dataQr;
  final List<SeatResponse> chosenSeats;
  final int scheduleId;

  final String roomName;
  final String movieName;
  final String dateTime;
  final String cost;
  final List<String> nameChosenSeats;

  @override
  TicketViewState createState() => TicketViewState();
}

class TicketViewState extends State<TicketView> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<TicketPageCubit>(context)
        .payment(widget.scheduleId, widget.chosenSeats);
  }

  void _showPaymentDialog(BuildContext context, bool paymentSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Lottie.asset(
                paymentSuccess
                    ? 'assets/animations/success.json'
                    : 'assets/animations/error.json',
                fit: BoxFit.fill,
              ),
              Text(
                paymentSuccess ? 'Congrates' : 'Oops!',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                paymentSuccess
                    ? 'Booking successfully'
                    : 'Something went wrong',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CupertinoDialogAction(
                onPressed: paymentSuccess
                    ? () {
                        context.pop();
                      }
                    : () {
                        for (var i = 0; i < 4; i++) {
                          context.pop();
                        }
                      },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(appColor),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  height: 40,
                  width: 100,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: const Center(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          elevation: 24,
        );
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Color.fromARGB(85, 255, 255, 255),
          content: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          elevation: 24,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<TicketPageCubit, TicketPageState>(
          listener: (context, state) {
        if (state is PaymentPageTicketState) {
          context.read<TicketCubit>().showTicket();
          _showPaymentDialog(context, true);
        } else if (state is TicketPageErrorState) {
          _showPaymentDialog(context, false);
        } else if (state is TicketPageLoadingState) {
          _showLoadingDialog(context);
        } 
      }, builder: (context, state) {
        if (state is TicketPageInitialState) {
          return pageWidget(false);
        } else {
          return pageWidget(true);
        }
      }),
    );
  }

  Widget pageWidget(bool paymentSuccess) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              paymentSuccess ? 'Your Ticket' : 'Payment',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(backgroundColor),
            centerTitle: true,
            actions: [
              paymentSuccess
                  ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        context.go(RouteName.home);
                      },
                    )
                  : const SizedBox.shrink(),
            ]),
        backgroundColor: const Color(backgroundColor),
        body: PopScope(
          canPop: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      paymentSuccess
                          ? const Center(child: QRGenerator(data: 'Your ticket'))
                          : Center(child: QRGenerator(data: widget.dataQr)),
                      paymentSuccess
                          ? const SizedBox.shrink()
                          : const Center(
                              child: Text(
                                'Scan QR for payment',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      BlocBuilder<TicketCubit, TicketState>(
                        builder: (context, state) {
                          if (state is TicketShowState) {
                            return ticketWidget();
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget ticketWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 40,
        ),
        Text(
          widget.movieName,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        InfoRow(label: 'Room', value: widget.roomName),
        InfoRow(label: 'Date', value: widget.dateTime),
        InfoRow(label: 'Cost', value: widget.cost),
        Column(
          children: List.generate(widget.nameChosenSeats.length, (index) {
            return InfoRow(
              label: index == 0 ? 'Seats' : null,
              value: widget.nameChosenSeats[index],
            );
          }),
        ),
      ],
    );
  }
}
