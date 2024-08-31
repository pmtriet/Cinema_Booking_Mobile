import 'package:cinemabooking/datalayer/services/dio_client.dart';
import 'package:dio/dio.dart';

class AuthKey {
  static const tokenKey = 'token';
}

class AuthApi {
  final Dio dio = DioClient.getInstance();

  Future<Response> login(
      {required String baseUrl,
      required String path,
      required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post(
        '$baseUrl$path',
        data: data,
      );
      return response;
    } catch (error) {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 400,
        data: {'status': 400, 'message': 'Something went wrong'},
      );
    }
  }

  Future<Response> logout({
    required String baseUrl,
    required String path,
    required String token,
  }) async {
    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer $token";
      final response = await dio.post('$baseUrl$path', data: '');
      return response;
    } catch (error) {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 400,
        data: {'status': 400, 'message': 'Something went wrong'},
      );
    }
  }

  Future<Response> register(
      {required String baseUrl,
      required String path,
      required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post(
        '$baseUrl$path',
        data: data,
      );
      return response;
    } catch (error) {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 400,
        data: {'status': 400, 'message': 'Something went wrong'},
      );
    }
  }

   Future<Response> checkExpireToken({
    required String baseUrl,
    required String path,
    required String token,
  }) async {
    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer $token";
      final response = await dio.get('$baseUrl$path', data: '');
      return response;
    } catch (error) {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 400,
        data: {'status': 400, 'message': 'Something went wrong'},
      );
    }
  }
}
