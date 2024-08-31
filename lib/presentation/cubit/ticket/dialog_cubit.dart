import 'package:flutter_bloc/flutter_bloc.dart';

class DialogCubit extends Cubit<int> {
  DialogCubit() : super(0);

  void showDialog(int index) {//0: not show, 1:dialog success, 2: dialog unsuccess
    emit(index);
  }
}