import 'package:cinemabooking/domain/data_request/auth/register_request.dart';
import 'package:cinemabooking/domain/repo_interface/auth_repo_interface.dart';
import 'package:cinemabooking/presentation/states/auth/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final IAuthRepository authRepository;

  RegisterCubit({required this.authRepository}) : super(RegisterInitialState());

  Future<void> validRegister() async {
    emit(RegisterInitialState());
  }

  Future<void> register(String email, String name, String password) async {
    emit(RegisterLoadingState());
    try {
      var registerRequestDTO =
          RegisterRequest(email: email, name: name, password: password);
      final registerResponse =
          await authRepository.register(registerRequestDTO);
      if (registerResponse != null) {
        if (registerResponse.success) {
          emit(RegisterSuccessState());
        } else {
          emit(RegisterErrorState(registerResponse.message));
        }
      } else {
        emit(RegisterErrorState('Error connection to server'));
      }
    } catch (e) {
      emit(RegisterErrorState('Something went wrong: ${e.toString()}'));
    }
  }
}
