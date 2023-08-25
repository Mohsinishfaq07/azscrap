import 'package:flutter/material.dart';

class contact_Us extends StatefulWidget {
  const contact_Us({Key? key}) : super(key: key);

  @override
  State<contact_Us> createState() => _contact_UsState();
}

class _contact_UsState extends State<contact_Us> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF4271B7),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            'Contact Us',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Contact Us Detail Will be provided here',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
