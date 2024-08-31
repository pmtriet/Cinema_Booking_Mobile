import 'package:cinemabooking/common/services/preference.dart';
import 'package:cinemabooking/config/sever_url.dart';
import 'package:cinemabooking/datalayer/data_response/auth/login_response.dart';
import 'package:cinemabooking/datalayer/data_response/auth/register_response.dart';
import 'package:cinemabooking/datalayer/services/auth_api.dart';
import 'package:cinemabooking/domain/data_request/auth/login_request.dart';
import 'package:cinemabooking/domain/data_request/auth/register_request.dart';
import 'package:cinemabooking/domain/repo_interface/auth_repo_interface.dart';

class AuthRepository implements IAuthRepository {
  final AuthApi authApi = AuthApi();

  @override
  Future<String?> login(LoginRequest loginRequestDTO) async {
    try {
      final response = await authApi.login(
        baseUrl: serverUrl,
        path: "/auth/login",
        data: loginRequestDTO.toJson(),
      );
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final tokenJson = responseData['data'] as Map<String, dynamic>;
        final loginResponseDTO = LoginResponse.fromJson(tokenJson);
        await Preferences.saveToken(loginResponseDTO.token);
        return null;
      } else {
        final responseData = response.data as Map<String, dynamic>;
        final errorMessage = responseData['message'] as String;
        return errorMessage;
      }
    } catch (e) {
      return "Something went wrong";
    }
  }

  @override
  Future<bool> logout() async {
    String? token = await Preferences.getToken();
    if (token != null) {
      try {
        final response = await authApi.logout(
          baseUrl: serverUrl,
          path: "/auth/logout",
          token: token,
        );

        if (response.statusCode == 200) {
          await Preferences.deleteToken();
          return true;
        } else if (response.statusCode == 401) {
          await Preferences.deleteToken();
          return true;
        }
      } catch (e) {
        return false;
      }
    }
    return true;
  }

  @override
  Future<RegisterResponse?> register(RegisterRequest registerRequestDTO) async {
    try {
      final response = await authApi.register(
        baseUrl: serverUrl,
        path: "/auth/register",
        data: registerRequestDTO.toJson(),
      );
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final registerResponseDTO =
            RegisterResponse(success: true, message: responseData['message']);
        return registerResponseDTO;
      } else {
        final responseData = response.data as Map<String, dynamic>;
        final registerResponseDTO =
            RegisterResponse(success: false, message: responseData['message']);
        return registerResponseDTO;
      }
    } catch (e) {
      final registerResponseDTO =
          RegisterResponse(success: false, message: "Something went wrong");
      return registerResponseDTO;
    }
  }

  @override
  Future<bool> checkToken() async {
    final String? token = await Preferences.getToken();
    if (token != null) {
      try {
        final response = await authApi.checkExpireToken(
          baseUrl: serverUrl,
          path: "/auth/checkToken",
          token: token,
        );
        if (response.statusCode == 200) {
          await Preferences.deleteToken();
          return true;
        } else  {
          return false;
        }
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
