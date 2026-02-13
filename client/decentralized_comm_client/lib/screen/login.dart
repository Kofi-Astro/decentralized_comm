// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../screen/chats.dart';
import '../services/local_user.dart';
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
    Icon? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,

      decoration: InputDecoration(
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          gapPadding: 10,
        ),
        suffixIcon: suffixIcon,
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Input some data';
        } else {
          return null;
        }
      },
    );
  }

  ElevatedButton authButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final username = _usernameController.text.trim();
          final password = _passwordController.text.trim();

          if (_haveAccount == false) {
            final success = await ApiService().createUser(username, password);

            if (success) {
              final user = await ApiService().loginUser(username, password);
              await LocalUserService.saveUser(user);

              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => ChatsPage(),
                ),
                (route) => false,
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Failed to create user')));
            }
          } else {
            try {
              final user = await ApiService().loginUser(username, password);
              await LocalUserService.saveUser(user);
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => ChatsPage()),
                (route) => false,
              );
            } catch (e) {
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Invalid credentials')));
            }
          }
        }
      },
      child: Text(_haveAccount == true ? 'Login' : 'Register'),
    );
  }

  Form formData(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _loginInputField(
            label: 'Username',
            controller: _usernameController,
            suffixIcon: Icon(Icons.person_rounded),
          ),

          SizedBox(height: 30),
          _loginInputField(
            label: 'Password',
            controller: _passwordController,
            obscureText: true,
            suffixIcon: Icon(Icons.lock_outline_rounded),
          ),
          SizedBox(height: 45),
          authButton(context),
          SizedBox(height: 60),
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
            child: formData(context),
          ),
        ),
      ),
    );
  }
}
