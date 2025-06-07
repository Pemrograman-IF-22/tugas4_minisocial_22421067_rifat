import 'package:flutter/material.dart';
import 'package:mini_socil_rifa_2242067/core/network/dio_client.dart';

class PostController {
  Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      final dio = await DioClient.instance;
      final response = await dio.get('/posts');
      debugPrint('Get Posts Response: ${response.data}');
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      debugPrint('Error Get Posts: $e');
      return [];
    }
  }

  Future<bool> createPost({
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    try {
      final dio = await DioClient.instance;
      final response = await dio.post('/posts', data: {
        'title': title,
        'content': content,
        'image_url': imageUrl,
      });

      debugPrint('Create Post Response: ${response.data}');
      return true;
    } catch (e) {
      debugPrint('Error Create Post: $e');
      return false;
    }
  }

  Future<bool> likePost(String postId) async {
    try {
      final dio = await DioClient.instance;
      final response = await dio.post('/posts/$postId/like');
      debugPrint('Like Post Response: ${response.data}');
      return true;
    } catch (e) {
      debugPrint('Error Like Post: $e');
      return false;
    }
  }

  Future<bool> unlikePost(String postId) async {
    try {
      final dio = await DioClient.instance;
      final response = await dio.delete('/posts/$postId/like');
      debugPrint('Unlike Post Response: ${response.data}');
      return true;
    } catch (e) {
      debugPrint('Error Unlike Post: $e');
      return false;
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      final dio = await DioClient.instance;
      final response = await dio.delete('/posts/$postId');
      debugPrint('Delete Post Response: ${response.data}');
      return true;
    } catch (e) {
      debugPrint('Error Delete Post: $e');
      return false;
    }
  }
} 