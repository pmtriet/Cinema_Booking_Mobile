import 'dart:async';
import 'package:cinemabooking/datalayer/services/dio_client.dart';
import 'package:dio/dio.dart';

class BookingApi {
  final Dio dio = DioClient.getInstance();

  Future<Response> getListSeats({
    required String baseUrl,
    required String path,
    required String token,
  }) async {
    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer $token";
      final response = dio.get(
        '$baseUrl$path',
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
}
