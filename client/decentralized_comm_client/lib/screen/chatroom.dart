import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart' as chat;

class ChatRoomPage extends StatefulWidget {
  final String title;

  final int chat;
  const ChatRoomPage({super.key, required this.title, required this.chat});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  chat.BubbleNormal(text: 'Hello kelvin', isSender: true),
                  chat.BubbleNormal(text: 'Hello there', isSender: false),
                ],
              ),
            ),

            chat.MessageBar(),
          ],
        ),
      ),
    );
  }
}
