import 'package:cinemabooking/domain/data_request/schedule/date.dart';
import 'package:cinemabooking/domain/repo_interface/movie_repo_interface.dart';
import 'package:cinemabooking/presentation/states/schedule/list_date_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ListDateCubit extends Cubit<ListDateState> {
  final IMovieRepository movieRepository;

  ListDateCubit({required this.movieRepository})
      : super(ListDateInitialState());

  Future<void> getDailyDates() async {
    try {
      final listDates = await movieRepository.getDailyDate();
      if (listDates != null) {
        var listDatesFormated =formatedListDates(listDates);
        emit(ListDateSuccessState(listDatetime: listDatesFormated));
      } else {
        emit(ListDateErrorState('Nothing to show'));
      }
    } catch (e) {
      emit(ListDateErrorState("Failed to get list datetimes: ${e.toString()}"));
    }
  }

  List<DateItem> formatedListDates(List<DateTime> listDatetimes) {
    List<DateItem> dateItems = [];

    for (int i = 0; i < listDatetimes.length; i++) {
      DateTime date = listDatetimes[i];
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
}
