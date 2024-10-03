import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService{

  HttpService();

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse('$url'),
        headers: headers,
      );
      print('getAPI :  $url');
      _handleResponse(response);
      return response;
    } catch (ex) {
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      String jsonResponse = jsonEncode(response);

      return http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  void _handleResponse(http.Response response) async {
    if (response.statusCode != 200) {
      print("error==> ${response.statusCode}");
      print("error==> ${response.body}");
    }
  }

}

class CrashedApiResponse {
  String? message;
  bool? success;
  int? statusCode;

  CrashedApiResponse({this.message = "Error Occur", this.success = false, this.statusCode = 500});

  CrashedApiResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    return data;
  }
}