import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';

class ApiService {
  // static const String baseUrl = "http://10.0.2.2:5000";  // Android
  static const String baseUrl = "http://127.0.0.1:5000"; // iOS

  // ######### USER RELATED API SERVICES ##############
  // Create new users
  // Future<User> createUser(String username, String password) async {
  Future<bool> createUser(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 201) {
      // return User.fromJson(jsonDecode(response.body));
      return true;
    } else {
      // throw Exception('Failed to create user');
      return false;
    }
  }

  Future<User> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'username': username, 'password': password}),
    );

    debugPrint("LOGIN STATUS: ${response.statusCode}");
    debugPrint("LOGIN BODY: ${response.body}");

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to log in user');
    }
  }

  // ##############   CHATS RELATED API SERVICES ################
  // Fetch list of chats for current user
  Future<List<Chat>> fetchChats(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/chats?user_id=$userId"),
    );

    final List data = jsonDecode(response.body);

    return data.map((e) => Chat.fromJson(e)).toList();
  }

  // Load chat

  // Fetch list of messages in database
  Future<List<Message>> fetchMessages(int chatId) async {
    final response = await http.get(Uri.parse("$baseUrl/messages/$chatId"));
    final List data = jsonDecode(response.body);

    return data.map((e) => Message.fromJson(e)).toList();
  }

  Future<void> sendMessage({
    required int chatId,
    required int senderId,
    required String content,
  }) async {
    await http.post(
      Uri.parse("$baseUrl/messages"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "chat_id": chatId,
        "sender_id": senderId,
        "content": content,
      }),
    );
  }
}
