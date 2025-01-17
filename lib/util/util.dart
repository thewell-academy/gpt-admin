import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:thewell_gpt_admin/util/server_config.dart';


String serverUrl = gptServerUrl;

Timer? _retryTimer;

Future<void> serverHandShake(Function(String, Color) updateStatus) async {

  try {
    final response = await http
        .get(Uri.parse('$serverUrl/ping'))
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      // If the response is not 200, change the theme and retry after 5 seconds
      updateStatus("서버 오류", Colors.red);

      // Retry after 5 seconds
      _retryTimer = Timer(const Duration(seconds: 5), () => serverHandShake(updateStatus));
    } else {
      updateStatus("더웰 관리자 페이지", Colors.black87);
      _retryTimer?.cancel();  // Stop retrying if the response is 200
    }
  } on TimeoutException catch (_) {
    // Handle timeout by updating theme and retrying after 5 seconds
    updateStatus("서버 연결 실패", Colors.orange);

    // Retry after 5 seconds
    _retryTimer = Timer(const Duration(seconds: 5), () => serverHandShake(updateStatus));
  } catch (e) {
    // Handle other errors by updating theme and retrying after 5 seconds
    print("Error occurred: $e");
    updateStatus("알 수 없는 오류", Colors.red);

    // Retry after 5 seconds
    _retryTimer = Timer(const Duration(seconds: 5), () => serverHandShake(updateStatus));
  }
}

Future<Map<String, dynamic>> fetchSubjectDetails(String subject) async {

  final response = await http
      .get(Uri.parse('$serverUrl/question-bank/subject-details/$subject'));

  return await jsonDecode(utf8.decode(response.bodyBytes));
}