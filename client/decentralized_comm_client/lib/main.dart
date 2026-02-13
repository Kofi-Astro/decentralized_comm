import 'package:flutter/material.dart';

import '../screen/chats.dart';
import '../screen/login.dart';
import '../services/local_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalyx Chat',
      home: FutureBuilder(
        future: LocalUserService.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final user = snapshot.data;

          if (user == null) {
            return LoginScreen();
          }

          return ChatsPage();
        },
      ),
    );
  }
}
