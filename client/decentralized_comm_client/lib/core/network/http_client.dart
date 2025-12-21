import 'package:decentralized_comm_client/core/config/api_routes.dart';
import 'package:dio/dio.dart';

class HttpClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiRoutes.baseUrl,
      connectTimeout: const Duration(seconds: 10),
    ),
  );
}
