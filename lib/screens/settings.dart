// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  String? JWDToken = null;
  String? Number = null;

  get_token() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    JWDToken = prefs.getString("Token");
    print("The sahre-pref token is ${JWDToken}");
  }

  get_number() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Number = prefs.getString("Number");
    print("The sahre-pref number is ${Number}");
  }

  change_Name() async {
    try {
      var map = new Map<String, dynamic>();
      map['user_number'] = Number;
      map['user_name'] = "Ali";

      http.Response response = await http.post(
        Uri.parse('https://auth.azscrap.com/api/user/edit-user'),
        headers: {
          "x-access-token": JWDToken!,
        },
        body: map,
        // body:  json.encode({
        //   'phoneNumber': "0383748377",
        //   'sessionInfo': "this is token info",
        // }),
      );
      print(response.body);
      print(json.decode(response.body)['statusMsg']);
      print(json.decode(response.body)['data']);
      // print("id:"+ id);
      // saveId(id);

      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => HomeScreen()));
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF4271B7),
          title: Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Form(
                child: TextFormField(
                  // controller: user_name,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  maxLines: 1,
                  minLines: 1,
                  autofocus: false,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    label: Text(
                      "New Name",
                      style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await get_token();
                await get_number();
                await change_Name();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'Submit'.toUpperCase(),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue[800]),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
