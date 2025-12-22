import 'package:decentralized_comm_client/screen/chats.dart';
import 'package:decentralized_comm_client/screen/login.dart';
import 'package:decentralized_comm_client/services/local_user.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final user = await LocalUserService.getUser();

  runApp(MyApp(isLoggedIn: user != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: isLoggedIn ? ChatsPage() : LoginScreen(),
    );
  }
}
