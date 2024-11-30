import 'package:cinemabooking/common/widgets/button.dart';
import 'package:cinemabooking/common/widgets/seat_item.dart';
import 'package:cinemabooking/config/route.dart';
import 'package:cinemabooking/config/ui.dart';
import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';
import 'package:cinemabooking/datalayer/repo/booking_repo.dart';
import 'package:cinemabooking/presentation/cubit/booking/booking_cubit.dart';
import 'package:cinemabooking/presentation/cubit/booking/chosen_seats_cubit.dart';
import 'package:cinemabooking/presentation/pages/booking/schedule_infor_bar.dart';
import 'package:cinemabooking/presentation/pages/booking/seat_status_circle.dart';
import 'package:cinemabooking/presentation/states/booking/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BookingPage extends StatelessWidget {
  const BookingPage(
      {super.key,
      required this.scheduleId,
      required this.movieName,
      required this.chosenDate,
      required this.startTime});
  final int scheduleId;
  final String movieName;
  final String chosenDate;
  final String startTime;
  @override
  Widget build(BuildContext context) {
    final bookingRepository = BookingRepository();
    return BlocProvider(
      create: (_) => BookingCubit(bookingRepository: bookingRepository),
      child: MaterialApp(
        home: BookingView(
          scheduleId: scheduleId,
          movieName: movieName,
          chosenDate: chosenDate,
          startTime: startTime,
        ),
      ),
    );
  }
}

class BookingView extends StatefulWidget {
  const BookingView(
      {super.key,
      required this.scheduleId,
      required this.movieName,
      required this.chosenDate,
      required this.startTime});

  final int scheduleId;
  final String movieName;
  final String startTime;
  final String chosenDate;

  @override
  BookingViewState createState() => BookingViewState();
}

class BookingViewState extends State<BookingView> {
  final ScrollController horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context
        .read<BookingCubit>()
        .getListSeats(widget.scheduleId, widget.chosenDate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(backgroundColor),
        body: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            switch (state){
              case BookingInitialState():
                return const Center(child: CircularProgressIndicator());
              case BookingSuccessState():
                return _bookingWidget(context, state.roomName, widget.chosenDate,
                  widget.startTime, state.listSeats);
              case BookingErrorState():
                return _errorWidget(context, state.errorMessage);
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _bookingWidget(BuildContext context, String roomName, String date,
      String startTime, List<SeatResponse> seats) {
    double deviceWidth = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (_) => ChosenSeatsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Room $roomName',
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                height: 64,
                color: const Color(backgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ScheduleInforBarWidget(
                        title: date,
                        icon: Icons.calendar_today,
                        width: deviceWidth / 2.34),
                    ScheduleInforBarWidget(
                        title: startTime,
                        icon: Icons.access_time,
                        width: deviceWidth / 2.34),
                  ],
                ),
              ),
              Container(
                color: const Color(backgroundColor),
                height: 50,
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SeatStatusCircleWidget(
                          title: 'Available', color: Color(appColor)),
                      SeatStatusCircleWidget(
                          title: 'Occupied', color: Colors.grey),
                      SeatStatusCircleWidget(
                          title: 'Chosen', color: Colors.green),
                    ]),
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/screen.png'),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: RawScrollbar(
                        controller: horizontalScrollController,
                        thumbVisibility: true,
                        thumbColor: const Color(appColor),
                        thickness: 1,
                        radius: const Radius.circular(8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScrollController,
                                child: SizedBox(
                                  width: deviceWidth,
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 10,
                                        crossAxisSpacing: 4,
                                        mainAxisSpacing: 2,
                                        childAspectRatio: 1.0,
                                      ),
                                      itemCount: seats.length,
                                      itemBuilder: (context, index) {
                                        return BlocBuilder<ChosenSeatsCubit,
                                                List<SeatResponse>>(
                                            builder: (context, chosenSeats) {
                                          return SeatItem(
                                              seat: seats[index],
                                              canSelected:
                                                  chosenSeats.length != 8,
                                              onTap: (seat) {
                                                if (seat.seatStatus ==
                                                    2) //after selected
                                                {
                                                  context
                                                      .read<ChosenSeatsCubit>()
                                                      .addSeat(seat);
                                                } else if (seat.seatStatus ==
                                                    0) {
                                                  //after unselected
                                                  context
                                                      .read<ChosenSeatsCubit>()
                                                      .removeSeat(seat);
                                                }
                                              });
                                        });
                                      }),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
              SizedBox(
                height: 80,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: BlocBuilder<ChosenSeatsCubit, List<SeatResponse>>(
                      builder: (context, chosenSeats) {
                    return AppButton(
                      title: chosenSeats.isEmpty ? "Booking" : "Buy ${chosenSeats.length} tickets - Total: ${chosenSeats.fold(0, (previousValue, element) => previousValue + element.seatPrice)}",
                      onTextButtonPressed: () {
                        sortChosenSeatsByName(chosenSeats);
                        chosenSeats.isNotEmpty
                            ? context.push(
                                RouteName.payment,
                                extra: {
                                  'scheduleId': widget.scheduleId,
                                  'chosenSeats': chosenSeats,
                                  'roomName': roomName,
                                },
                              )
                            : null;
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorWidget(BuildContext context, String? errorMessage) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Error",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
        body: Center(
          child: Text(
            errorMessage ?? "Error to show seats",
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}

void sortChosenSeatsByName(List<SeatResponse> chosenSeats) {
  chosenSeats.sort((a, b) => compareSeatNames(a.seatName, b.seatName));
}

int compareSeatNames(String seat1, String seat2) {
  String letter1 = seat1[0];
  String letter2 = seat2[0];

  int number1 = int.parse(seat1.substring(1));
  int number2 = int.parse(seat2.substring(1));

  int letterComparison = letter1.compareTo(letter2);
  if (letterComparison != 0) {
    return letterComparison;
  }

  return number1.compareTo(number2);
}
