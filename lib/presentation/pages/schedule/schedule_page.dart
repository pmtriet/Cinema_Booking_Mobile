import 'package:cinemabooking/common/widgets/day_item.dart';
import 'package:cinemabooking/config/route.dart';
import 'package:cinemabooking/config/ui.dart';
import 'package:cinemabooking/datalayer/data_response/schedule/schedule.dart';
import 'package:cinemabooking/datalayer/repo/movie_repo.dart';
import 'package:cinemabooking/datalayer/repo/schedule_repo.dart';
import 'package:cinemabooking/domain/data_request/schedule/date.dart';
import 'package:cinemabooking/presentation/cubit/schedule/date_cubit.dart';
import 'package:cinemabooking/presentation/cubit/schedule/list_date_cubit.dart';
import 'package:cinemabooking/presentation/cubit/schedule/schedule_cubit.dart';
import 'package:cinemabooking/presentation/pages/schedule/schedule_by_room.dart';
import 'package:cinemabooking/presentation/states/schedule/list_date_state.dart';
import 'package:cinemabooking/presentation/states/schedule/schedule_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage(
      {super.key, required this.movieId, required this.movieName});
  final int movieId;
  final String movieName;

  @override
  Widget build(BuildContext context) {
    final movieRepository = MovieRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DateSelectionCubit(),
        ),
        BlocProvider(
          create: (context) => ListDateCubit(movieRepository: movieRepository),
        ),
      ],
      child: ScheduleView(
        movieId: movieId,
        movieName: movieName,
      ),
    );
  }
}

class ScheduleView extends StatelessWidget {
  const ScheduleView(
      {super.key, required this.movieId, required this.movieName});
  final int movieId;
  final String movieName;

  @override
  Widget build(BuildContext context) {
    List<DateItem> dateItems = [];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            movieName,
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
        body: BlocBuilder<ListDateCubit, ListDateState>(
            builder: (context, state) {
          if (state is ListDateInitialState) {
            context.read<ListDateCubit>().getDailyDates();
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ListDateErrorState) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (state is ListDateSuccessState) {
            dateItems = state.listDatetime;
            return BlocBuilder<DateSelectionCubit, int>(
                builder: (context, selectedIndex) {
              for (int i = 0; i < dateItems.length; i++) {
                dateItems[i].isSelected = i == selectedIndex;
              }
              String chosenDate =
                  '${dateItems[selectedIndex].shortDay}, ${dateItems[selectedIndex].displayDate}';
              final scheduleRepository = ScheduleRepository();
              return BlocProvider(
                create: (_) =>
                    ScheduleCubit(scheduleRepository: scheduleRepository),
                child: BlocBuilder<ScheduleCubit, ScheduleState>(
                  builder: (context, state) {
                    switch (state){
                      case ScheduleLoadingState():
                        context.read<ScheduleCubit>()
                          .getSchedulesByMoviesIdFollowDay(
                              movieId, dateItems[selectedIndex].fullDay);
                        return const Center(child: CircularProgressIndicator());
                      case ScheduleSuccessState():
                        return _scheduleWidget(context, movieName, movieId,
                          dateItems, state.schedules, chosenDate);
                      case ScheduleErrorState():
                        return _errorWidget(context, movieName, movieId,
                          dateItems, state.errorMessage);
                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              );
            });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}

Widget _scheduleWidget(
  BuildContext context,
  String movieName,
  int movieId,
  List<DateItem> dateItems,
  Map<int, Map<String, List<Schedule>>> scheduleItems,
  String chosenDate,
) {
  return Scaffold(
      backgroundColor: const Color(backgroundColor),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(children: [
          SizedBox(
              height: 90,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dateItems.length, (index) {
                    return DayItemWidget(
                      item: dateItems[index],
                      onTap: (fullDay) {
                        context
                            .read<ScheduleCubit>()
                            .getSchedulesByMoviesIdFollowDay(movieId, fullDay);
                        context.read<DateSelectionCubit>().selectDate(index);
                      },
                    );
                  }))),
          Expanded(
            child: SingleChildScrollView(
                child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: scheduleItems.entries.expand((entry) {
                return entry.value.entries.map((subEntry) {
                  return ScheduleItemRowsWidget(
                    roomName: subEntry.key,
                    listSchedule: subEntry.value,
                    onTap: (scheduleId, startTime) {
                      context.push(
                          '${RouteName.booking}/$scheduleId/$movieName/$chosenDate/$startTime');
                    },
                  );
                }).toList();
              }).toList(),
            )),
          ),
        ]),
      ));
}

Widget _errorWidget(BuildContext context, String movieName, int movieId,
    List<DateItem> dateItems, String? errorMessage) {
  return SafeArea(
    child: Scaffold(
        backgroundColor: const Color(backgroundColor),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(children: [
            SizedBox(
                height: 90,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(dateItems.length, (index) {
                      return DayItemWidget(
                        item: dateItems[index],
                        onTap: (fullDay) {
                          context
                              .read<ScheduleCubit>()
                              .getSchedulesByMoviesIdFollowDay(
                                  movieId, fullDay);
                          context.read<DateSelectionCubit>().selectDate(index);
                          //change dateItem[index] state
                          for (int i = 0; i < dateItems.length; i++) {
                            if (i != index) {
                              dateItems[i].isSelected = false;
                            }
                          }
                        },
                      );
                    }))),
            Expanded(
                child: Center(
                    child: errorMessage != null
                        ? Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.white),
                          )
                        : const SizedBox.shrink())),
          ]),
        )),
  );
}

List<DateItem> generateDateItems(List<DateTime> listDates) {
  List<DateItem> dateItems = [];
  DateTime currentDate = DateTime.now();

  for (int i = 0; i < 7; i++) {
    DateTime date = currentDate.add(Duration(days: i));
    String shortday = DateFormat('EEEE').format(date).substring(0, 2);
    String formattedDisplayDate = DateFormat('dd').format(date);
    String formattedFullDate = DateFormat('yyyy-MM-dd').format(date);

    dateItems.add(DateItem(
      id: i,
      shortDay: shortday,
      displayDate: formattedDisplayDate,
      fullDay: formattedFullDate,
      isSelected: i == 0 ? true : false,
    ));
  }
  return dateItems;
}

String formattedCurrentDay() {
  DateTime currentDate = DateTime.now();

  String shortday = DateFormat('EEEE').format(currentDate).substring(0, 2);
  String formattedDisplayDate = DateFormat('dd').format(currentDate);

  String formattedDate = '$shortday, $formattedDisplayDate';

  return formattedDate;
}
