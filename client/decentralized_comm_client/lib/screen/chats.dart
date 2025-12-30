import 'package:decentralized_comm_client/screen/login.dart';
import 'package:decentralized_comm_client/services/local_user.dart';
import 'package:flutter/material.dart';

import '../models/chat.dart';
import '../screen/chatroom.dart';
import '../services/api.dart';
import '../shared/pages/contacts.dart';

enum PopUpList { newChat, logout, settings }

class ChatsPage extends StatefulWidget {
  final int userId;
  const ChatsPage({super.key, required this.userId});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late Future<List<Chat>> _chatsFuture;

  @override
  void initState() {
    super.initState();
    // initChats();
    _chatsFuture = _loadChats();
  }

  Future<List<Chat>> _loadChats() async {
    final user = await LocalUserService.getUser();
    return ApiService().fetchChats(user!.id);
  }

  Future<void> initChats() async {
    final user = await LocalUserService.getUser();
    _chatsFuture = ApiService().fetchChats(user!.id);
    setState(() {});
  }

  Widget _buildChatList() {
    return FutureBuilder<List<Chat>>(
      future: _chatsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final chats = snapshot.data;
        if (chats == null || chats.isEmpty) {
          return Center(child: Text('No chats found. Begin a chat....'));
        }

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return _buildListTile(chat);
          },
        );
      },
    );
  }

  int index = 0;
  PopUpList? selectedItem;
  bool isChatEmpty = true;

  Widget _buildListTile(Chat chat) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text(
        chat.recipientUsername ??
            (chat.isGroup ? 'Group Chat' : 'Unknown User'),
      ),
      subtitle: Text("Tap to open"),
      trailing: Column(children: [Text('00:00'), Text('2')]),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(
              title:
                  chat.recipientUsername ??
                  (chat.isGroup ? 'Group Chat' : 'Unknown User'),
              chat: chat.id,
            ),
          ),
        );
      },
    );
  }

  PopupMenuItem<PopUpList> _popUpMenuItem({
    required BuildContext ctx,
    required String label,
    required Function() onTap,
    required PopUpList value,
  }) {
    return PopupMenuItem(value: value, onTap: onTap, child: Text(label));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chats'),
          backgroundColor: const Color.fromARGB(255, 82, 104, 169),
          actions: [
            PopupMenuButton<PopUpList>(
              icon: Icon(Icons.more_vert),
              initialValue: selectedItem,
              onSelected: (PopUpList item) {
                setState(() {
                  selectedItem = item;
                });
              },
              itemBuilder: (context) => <PopupMenuEntry<PopUpList>>[
                _popUpMenuItem(
                  value: PopUpList.newChat,
                  ctx: context,
                  label: 'New Chat',
                  onTap: () async {
                    final shouldRefresh = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ContactsPage(),
                      ),
                    );
                    if (shouldRefresh == true) {
                      await initChats();
                    }
                  },
                ),
                _popUpMenuItem(
                  value: PopUpList.logout,
                  ctx: context,
                  label: 'Logout',
                  onTap: () async {
                    await LocalUserService.clear();
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        body: _buildChatList(),
      ),
    );
  }
}
