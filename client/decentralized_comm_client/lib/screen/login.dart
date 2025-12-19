import 'package:decentralized_comm_client/screen/chats.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final String username;
  late final String password;
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
                    onPressed: () {
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(builder: (context) => ChatsPage()),
                      // );

                      if (_formKey.currentState!.validate()) {
                        username = _usernameController.text;
                        password = _passwordController.text;

                        print('Username: ${_usernameController.text}');
                        print('Password: ${_passwordController.text}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User Verified')),
                        );
                      }
                    },
                    child: Text('Log In'),
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
