import 'package:cinemabooking/common/services/preference.dart';
import 'package:cinemabooking/common/widgets/toast.dart';
import 'package:cinemabooking/presentation/cubit/auth/app_cubit.dart';
import 'package:dio/dio.dart';

class DioClient {
  static final Dio _dio = Dio();

  static Dio getInstance() {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        String errorMessage = 'Unknown error';
        int statusCode = 0;
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            errorMessage = 'Connection timeout error';
            statusCode = 408;
            break;
          case DioExceptionType.sendTimeout:
            errorMessage = 'Send timeout error';
            statusCode = 408;
            break;
          case DioExceptionType.receiveTimeout:
            errorMessage = 'Receive timeout error}';
            statusCode = 408;
            break;
          case DioExceptionType.badResponse:
            var errorResponse = e.response?.data as Map<String, dynamic>;
            errorMessage = errorResponse['message'] as String;
            statusCode = errorResponse['statusCode'] as int;
            break;
          case DioExceptionType.cancel:
            errorMessage = 'Request cancelled';
            statusCode = 499;
            break;
          case DioExceptionType.connectionError:
            errorMessage = 'Connection error';
            statusCode = 500;
            break;
          default:
            errorMessage = 'Unknown error';
            statusCode = 500;
        }
        if (statusCode == 401) {
          ToastMessage.showToast("Session expired. Please log in again.");
          await Preferences.deleteToken();
          AppAuthCubit().logout();
        } else {
          final response = Response(
            requestOptions: e.requestOptions,
            statusCode: statusCode,
            data: {'status': statusCode, 'message': errorMessage},
          );
          handler.resolve(response);
        }
      },
    ));
    return _dio;
  }
}
