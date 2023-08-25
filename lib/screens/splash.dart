// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../Provider/User Provider.dart';
import '../model/User_model.dart';
import 'bottom_navigation_bar.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String? jwtToken ;
  String? number  ;
  String statusMsg = "";
  int statusCode = 0;
  bool isLoading = false;

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    jwtToken = prefs.getString("Token");
    print("The shared-pref token is $jwtToken");
  }

  getNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    number = prefs.getString("Number");
    print("The shared-pref number is $number");
  }

  numberValidation() async {
    try {
      var map = Map<String, dynamic>();
      map['user_number'] = number;
    //  map['sessionInfo'] = "qXbVXEFggiOwAeLG3djinD5ZI4S2";

      http.Response response = await http.post(
        Uri.parse(
          'https://auth.azscrap.com/api/user/validate-phone-number',
          //'',
        ),
        headers: {
          "x-access-token": jwtToken!,
        },
        body: map,
        // body:  json.encode({
        //   'phoneNumber': "0383748377",
        //   'sessionInfo': "this is token info",
        // }),
      );
      // print(response.body);
      print(json.decode(response.body)['statusMsg']);
      statusCode = json.decode(response.body)['statusCode'];
      statusMsg = json.decode(response.body)['statusMsg'];
      // print(json.decode(response.body)['data']);
      // print("id:"+ id);
      // saveId(id);

      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => HomeScreen()));
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    setState(() {
      isLoading = true;
    });
    await getToken();
    await getNumber();
    if (jwtToken != null) {
      await numberValidation();
      if (statusCode == 200) {
        if (statusMsg == "USER ALREADY REGISTERED!") {
          await Provider.of<UserProvider>(context, listen: false)
              .FetchUser(number!, jwtToken!);
        } else {
          Provider.of<UserProvider>(context, listen: false).Adduser(
            UserModel(
              user_id: number,
              user_number: number!,
              is_registered: false,
            ),
          );
        }
        setState(() {
          isLoading = false;
        });
        Timer(const Duration(milliseconds: 1), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MyNavigationBar(
                    jwtToken: jwtToken!,
                    number: number!,
                    index: 0,
                  )));
        });
      } else {
        setState(() {
          isLoading = true;
        });
      }
    } else {
      Timer(const Duration(milliseconds: 1), () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: isLoading
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Image(
                        image: AssetImage('assets/splash.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 52.h,
                      left: 40.w,
                      right: 40.w,
                      child: SpinKitCircle(
                        size: 75,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ))
            : Image(
                image: AssetImage('assets/splash.jpeg'),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
