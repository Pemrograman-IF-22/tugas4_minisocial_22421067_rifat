import 'package:flutter/material.dart';
import 'package:mini_socil_rifa_2242067/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class AuthController {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final dio = await DioClient.instance;
      final response = await dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      debugPrint('Login Response: ${response.data}');
      final token = response.data['token'];
      final user = response.data['user'];
      await saveToken(token);
      await saveUser(user);
      return true;
    } catch (e) {
      debugPrint('Error Login: $e');
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final dio = await DioClient.instance;
      final response = await dio.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      debugPrint('Register Response: ${response.data}');
      final token = response.data['token'];
      final user = response.data['user'];
      await saveToken(token);
      await saveUser(user);
      return true;
    } catch (e) {
      debugPrint('Error Register: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final dio = await DioClient.instance;
      final response = await dio.post('/logout');
      debugPrint('Logout Response: ${response.data}');
      await removeToken();
      await removeUser();
      return true;
    } catch (e) {
      debugPrint('Error Logout: $e');
      await removeToken();
      await removeUser();
      return false;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final dio = await DioClient.instance;
      final response = await dio.get('/profile');
      debugPrint('Profile Response: ${response.data}');
      final user = response.data['data'];
      await saveUser(user);
      return user;
    } catch (e) {
      debugPrint('Error Get Profile: $e');
      return null;
    }
  }

  Future<bool> updateProfile({
    required String name,
    String? bio,
  }) async {
    try {
      final dio = await DioClient.instance;
      final response = await dio.put('/profile', data: {
        'name': name,
        'bio': bio,
      });
      debugPrint('Update Profile Response: ${response.data}');
      final user = response.data['data'];
      await saveUser(user);
      return true;
    } catch (e) {
      debugPrint('Error Update Profile: $e');
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);
    if (userStr == null) return null;
    return jsonDecode(userStr) as Map<String, dynamic>;
  }

  Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
