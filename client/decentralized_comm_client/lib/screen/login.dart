// ignore_for_file: use_build_context_synchronously

import 'package:decentralized_comm_client/screen/chats.dart';
import 'package:decentralized_comm_client/services/local_user.dart';
import 'package:flutter/material.dart';

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

  bool _haveAccount = false;

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
                      if (_formKey.currentState!.validate()) {
                        final username = _usernameController.text.trim();
                        final password = _passwordController.text.trim();

                        if (_haveAccount == false) {
                          final success = await ApiService().createUser(
                            username,
                            password,
                          );

                          if (success) {
                            final user = await ApiService().loginUser(
                              username,
                              password,
                            );
                            await LocalUserService.saveUser(user);

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('User created successfully'),
                              ),
                            );
                            if (!mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (BuildContext context) => ChatsPage(),
                              ),
                              (route) => false,
                            );
                          } else {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to create user')),
                            );
                          }
                        } else {
                          try {
                            final user = await ApiService().loginUser(
                              username,
                              password,
                            );
                            await LocalUserService.saveUser(user);
                            if (!mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => ChatsPage()),
                              (route) => false,
                            );
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid credentials')),
                            );
                          }
                        }
                      }
                    },
                    child: Text(_haveAccount == true ? 'Login' : 'Register'),
                  ),

                  TextButton(
                    onPressed: () {
                      if (_haveAccount == false) {
                        setState(() {
                          _haveAccount = true;
                        });
                      } else {
                        setState(() {
                          _haveAccount = false;
                        });
                      }
                    },
                    child: Text(
                      _haveAccount == false
                          ? 'Already have an account, Log In'
                          : 'Sign Up to Register',
                    ),
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
