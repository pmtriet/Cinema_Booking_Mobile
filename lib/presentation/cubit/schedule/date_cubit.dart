import 'package:flutter_bloc/flutter_bloc.dart';

class DateSelectionCubit extends Cubit<int> {
  DateSelectionCubit() : super(0);

  void selectDate(int index) {
    emit(index);
  }
}
