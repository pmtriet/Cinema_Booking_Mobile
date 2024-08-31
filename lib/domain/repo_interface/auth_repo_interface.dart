import 'package:cinemabooking/datalayer/data_response/auth/register_response.dart';
import 'package:cinemabooking/domain/data_request/auth/login_request.dart';
import 'package:cinemabooking/domain/data_request/auth/register_request.dart';

abstract class IAuthRepository {
  Future<String?> login(LoginRequest loginRequestDTO);
  Future<RegisterResponse?> register(RegisterRequest registerRequestDTO);
  Future<bool> logout();
  Future<bool> checkToken();
}
