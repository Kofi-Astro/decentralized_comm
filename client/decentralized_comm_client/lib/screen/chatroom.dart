import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart' as chat;

class ChatRoomPage extends StatefulWidget {
  final String name;
  const ChatRoomPage({super.key, required this.name});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.name)),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  children: [chat.BubbleNormal(text: 'Hello there')],
                ),
              ),
            ),

            chat.MessageBar(),
          ],
        ),
      ),
    );
  }
}
