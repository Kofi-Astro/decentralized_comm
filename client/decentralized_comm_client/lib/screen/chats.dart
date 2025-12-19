import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screen/chatroom.dart';
import '../services/api.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  int index = 0;

  Widget _buildListTile(String name) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text(name),
      subtitle: Text("I'm gonna be there soon"),
      trailing: Column(children: [Text('00:00'), Text('2')]),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ChatRoomPage(name: name)),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chats'),
          backgroundColor: const Color.fromARGB(255, 47, 67, 126),
        ),
        // body: ListView.builder(itemBuilder: _chatListItem, itemCount: 10),
        body: ListView(
          children: [
            _buildListTile('Kelvin'),
            _buildListTile('Astro'),
            _buildListTile('Captain'),
          ],
        ),
      ),
    );
  }
}
