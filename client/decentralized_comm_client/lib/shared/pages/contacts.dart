// ignore_for_file: use_build_context_synchronously

import 'package:decentralized_comm_client/screen/chatroom.dart';
import 'package:decentralized_comm_client/services/local_user.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/api.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late Future<List<User>> userList;

  @override
  void initState() {
    super.initState();
    userList = _loadUsers();
  }

  Future<List<User>> _loadUsers() {
    return ApiService().getUsers();
  }

  Widget _buildContactList() {
    return FutureBuilder<List<User>>(
      future: userList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final users = snapshot.data;
        if (users == null || users.isEmpty) {
          return Center(child: Text('No users found in the system'));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: Text(user.username),
              // onTap: () async {
              //   final currentUser = await LocalUserService.getUser();

              //   final chat = await ApiService().createOrFetchChats([
              //     currentUser!.id,
              //     user.id,
              //   ]);

              //   if (!mounted) return;

              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) =>
              //           ChatRoomPage(title: user.username, chat: chat.id),
              //     ),
              //   );

              //   Navigator.pop(context, true);
              // },
              onTap: () async {
                try {
                  final currentUser = await LocalUserService.getUser();

                  if (currentUser!.id == user.id) return;

                  final chat = await ApiService().createOrFetchChats([
                    currentUser.id,
                    user.id,
                  ]);

                  if (!mounted) return;

                  // 1️⃣ Navigate to chatroom
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoomPage(
                        chat: chat.id,
                        title: chat.recipientUsername ?? "Chat",
                      ),
                    ),
                  );

                  // 2️⃣ Tell ChatsPage to refresh
                  Navigator.pop(context, true);
                } catch (e) {
                  debugPrint("CHAT CREATE ERROR: $e");
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: _buildContactList(),
    );
  }
}
