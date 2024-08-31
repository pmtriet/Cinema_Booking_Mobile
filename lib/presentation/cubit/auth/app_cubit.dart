import 'package:cinemabooking/datalayer/repo/auth_repo.dart';
import 'package:cinemabooking/presentation/states/auth/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppAuthCubit extends Cubit<AppAuthState> {
  final AuthRepository authRepository = AuthRepository();

  AppAuthCubit._internal() : super(LogOut()) {
    //private constructor
    authRepository.checkToken().then((checkToken) {
      if (checkToken) {
        emit(LogIn());
      } else {
        emit(LogOut());
      }
    });
  }

  factory AppAuthCubit() {
    //return instance existed when create new AppAuthCubit
    return _instance;
  }

  static final AppAuthCubit _instance =
      AppAuthCubit._internal(); //only object represents for AppAuthCubit

  void login() {
    emit(LogIn());
  }

  void logout() {
    emit(LogOut());
  }
}/*
class AppAuthCubit extends Cubit<AppAuthState> {

  AppAuthCubit._internal(): super(LoggedOut());//private constructor

   factory AppAuthCubit() {//return instance existed when create new AppAuthCubit
    return _instance;
  }

  static final AppAuthCubit _instance = AppAuthCubit._internal();//only object represents for AppAuthCubit
  
  void login() {
    emit(LoggedIn());
  }

  void logout() {
    emit(LoggedOut());
  }
}
- At the tirst time calling AppAuthCubit():
the only instance of class _instance will be create by 
static final AppAuthCubit _instance = AppAuthCubit._internal()

AppAuthCubit._internal() is a private constructor using for create an object of class

Then running factory AppAuthCubit() {return _instance;} to return the only instance

- At next times calling AppAuthCubit():
Run factory AppAuthCubit() {return _instance;} to return the only instance

 */