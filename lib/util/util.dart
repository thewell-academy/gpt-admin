import 'package:platform_device_id/platform_device_id.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';  // Import for Timer


String serverUrl = "http://172.30.1.51:8000";

Timer? _retryTimer;

Future<void> serverHandShake(Function(String, Color) updateStatus) async {

  try {
    String? deviceId = await PlatformDeviceId.getDeviceId;

    final response = await http
        .get(Uri.parse('$serverUrl/ping'))
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      // If the response is not 200, change the theme and retry after 5 seconds
      updateStatus("서버 오류", Colors.red);

      // Retry after 5 seconds
      _retryTimer = Timer(const Duration(seconds: 5), () => serverHandShake(updateStatus));
    } else {
      updateStatus("더웰 GPT 관리자 페이지", Colors.black87);
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