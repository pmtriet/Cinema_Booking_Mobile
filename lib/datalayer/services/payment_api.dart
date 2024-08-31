import 'package:cinemabooking/datalayer/services/dio_client.dart';
import 'package:dio/dio.dart';

class PaymentApi {
  final Dio dio=  DioClient.getInstance();

  Future<Response> payment({
    required String baseUrl,
    required String path, 
    required String token,
    required Map<String, dynamic> data
  }) async {
    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer $token";
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
}