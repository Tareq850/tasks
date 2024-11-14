import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:assessment/core/packages/statusrequest.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:retry/retry.dart';
import '../functions/check_internet.dart';
class Crud {
  Future<http.Client> _createClient() async {
    final SecurityContext context = SecurityContext(withTrustedRoots: true);
    // context.setTrustedCertificates('path_to_your_cert.pem');
    final httpClient = IOClient(HttpClient(context: context));
    return httpClient;
  }

  Either<StatusRequest, Map> _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          Map responseBody = jsonDecode(response.body);
          return Right(responseBody);
        } catch (e) {
          return const Left(StatusRequest.serverError);
        }
      case 401:
        return const Left(StatusRequest.serverError);
      case 403:
        return const Left(StatusRequest.serverError);
      case 404:
        return const Left(StatusRequest.serverError);
      default:
        return const Left(StatusRequest.serverError);
    }
  }
  Future<Either<StatusRequest, Map>> postRequest(String url, Map<String, dynamic> data, String token) async {
    if (await checkInternet()) {
      try {
        const r = RetryOptions(maxAttempts: 3, delayFactor: Duration(seconds: 2));
        final client = await _createClient();
        final response = await r.retry(
              () async {
            final res = await client.post(
              Uri.parse(url),
              body: jsonEncode(data),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            );
            return res;
          },
          retryIf: (e) => e is http.ClientException || e is SocketException || e is TimeoutException, // إضافة TimeoutException
        );

        client.close();
        return _handleResponse(response);

      } catch (e) {
        print('Error: $e');
        return const Left(StatusRequest.serverError); // في حالة حدوث خطأ أثناء الاتصال
      }
    } else {
      return const Left(StatusRequest.internetNotFound); // في حالة عدم وجود اتصال بالإنترنت
    }
  }
}
