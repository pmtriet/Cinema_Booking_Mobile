import 'package:cinemabooking/datalayer/services/dio_client.dart';
import 'package:dio/dio.dart';

class ScheduleApi {
  final Dio dio = DioClient.getInstance();

  Future<Response> getScheduleByIdFollowDay(
      {required String baseUrl,
      required String path,
      required Map<String, dynamic> data}) async {
    try {
      final response = dio.post(
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

  Future<Response> getScheduleInfor({
    required String baseUrl,
    required String path,
  }) async {
    try {
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

  Future<Response> getScheduleById({
    required String baseUrl,
    required String path,
  }) async {
    try {
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
