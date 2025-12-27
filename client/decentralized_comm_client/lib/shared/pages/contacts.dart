import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../services/api.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: Center(child: Text('No contacts to show')),
    );
  }
}
