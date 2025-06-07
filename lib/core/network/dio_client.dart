import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DioClient {
  static Dio? _dio;
  static bool _initialized = false;

  static Future<Dio> get instance async {
    if (!_initialized) {
      await _initDio();
    }
    return _dio!;
  }

  static Future<void> _initDio() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api-social.ahmadlabs.my.id/api',
      ),
    );

    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Clear token
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('auth_token');
            await prefs.remove('user_data');
            // Redirect to login
            navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
          }
          return handler.next(e);
        },
      ),
    );

    _initialized = true;
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();