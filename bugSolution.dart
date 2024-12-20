```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData() async {
  try {
    final response = await http.get(Uri.parse('https://api.example.com/data'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      // More specific exception handling based on status codes
      throw HttpException('HTTP request failed with status: ${response.statusCode}', response.body);
    }
  } on FormatException catch (e) {
    // Handle JSON decoding errors
    throw DataFormatException('Failed to parse JSON: ${e.message}', response?.body);
  } on SocketException catch (e) {
    // Handle network errors
    throw NetworkException('Network error: ${e.message}');
  } on Exception catch (e) {
    // Handle other unexpected exceptions
    rethrow; // Re-throw for handling at a higher level
  }
}

//Custom Exception classes for better error identification
class HttpException implements Exception {
  final String message;
  final String? body;
  HttpException(this.message, this.body);
  @override
  String toString() => "HttpException: $message, Body: $body";
}

class DataFormatException implements Exception {
  final String message;
  final String? body;
  DataFormatException(this.message, this.body);
  @override
  String toString() => "DataFormatException: $message, Body: $body";
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => "NetworkException: $message";
}
```