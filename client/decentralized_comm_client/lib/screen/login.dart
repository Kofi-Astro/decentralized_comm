import 'package:decentralized_comm_client/screen/chats.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextFormField _loginInputField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,

      decoration: InputDecoration(label: Text(label)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Input some data';
        } else {
          return null;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(18),
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _loginInputField(
                    label: 'Username',
                    controller: _usernameController,
                  ),
                  SizedBox(height: 20),
                  _loginInputField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(builder: (context) => ChatsPage()),
                      // );

                      if (_formKey.currentState!.validate()) {
                        final username = _usernameController.text.trim();
                        final password = _passwordController.text.trim();

                        final success = await ApiService().createUser(
                          username,
                          password,
                        );

                        if (!mounted) return;

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User created successfully'),
                            ),
                          );
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => ChatsPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to create user')),
                          );
                        }

                        print('Username: ${_usernameController.text}');
                        print('Password: ${_passwordController.text}');
                      }
                    },
                    child: Text('Sign Up'),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: Text('Already have an account, Log In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
