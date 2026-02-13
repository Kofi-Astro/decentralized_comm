import 'package:decentralized_comm_client/services/api.dart';
import 'package:decentralized_comm_client/services/local_user.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart' as chat;

import '../models/message.dart';
import 'dart:async';

class ChatRoomPage extends StatefulWidget {
  final String title;

  final int chatId;
  const ChatRoomPage({super.key, required this.title, required this.chatId});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  List<Message> _messages = [];
  bool _loading = true;
  Timer? _pollingTimer;
  bool _isTyping = false;

  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    final user = await LocalUserService.getUser();

    currentUserId = user!.id;

    await _refreshMessages();

    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isTyping) {
        _refreshMessages();
      }
    });
  }

  Future<void> _refreshMessages() async {
    final freshMessages = await ApiService().fetchMessages(widget.chatId);
    if (!mounted) return;
    setState(() {
      _messages = freshMessages;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isSender = message.senderId == currentUserId;

                  return chat.BubbleNormal(
                    text: message.content,
                    isSender: isSender,
                    color: isSender
                        ? const Color(0xFF5268A9)
                        : Colors.grey.shade300,
                    textStyle: TextStyle(
                      color: isSender ? Colors.white : Colors.black,
                    ),
                  );
                },
              ),
            ),

            chat.MessageBar(
              onTextChanged: (text) {
                _isTyping = text.isNotEmpty;
              },
              onSend: (text) async {
                if (text.trim().isEmpty || currentUserId == null) return;
                _isTyping = false;
                final tempMessage = Message(
                  id: -1,
                  chatId: widget.chatId,
                  content: text,
                  senderId: currentUserId!,
                  createdAt: DateTime.now().toIso8601String(),
                );
                setState(() {
                  _messages.add(tempMessage);
                });

                await ApiService().sendMessage(
                  chatId: widget.chatId,
                  senderId: currentUserId!,
                  content: text,
                );

                await _refreshMessages();
              },
            ),
          ],
        ),
      ),
    );
  }
}
