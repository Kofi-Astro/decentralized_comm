import 'package:decentralized_comm_client/screen/chatroom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatRoomPage(name: user.username),
                  ),
                );
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
