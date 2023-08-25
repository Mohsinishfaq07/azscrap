import 'dart:convert';
// import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Provider/User Provider.dart';
import '../constants.dart';
import '../model/User_model.dart';
import '../screens/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VerifyOtpScreen extends StatelessWidget {
  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );
  final String phoneNumber;
  String? userId = "";
  String? _enteredOTP;
  String jwtToken = "123456";

  VerifyOtpScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  numberAuthentication() async {
    try {
      var map = new Map<String, dynamic>();
      map['phoneNumber'] = phoneNumber;
   //   map['sessionInfo'] = user_id;

      http.Response response = await http.post(
        Uri.parse(
            'https://auth.azscrap.com/api/user/authenticating-phone-number'),
        body: map,
        // body:  json.encode({
        //   'phoneNumber': "0383748377",
        //   'sessionInfo': "this is token info",
        // }),
      );
      // print(response.body);
      // print(json.decode(response.body)['statusMsg']);
      // print(json.decode(response.body)['data']);
      // JWD_token = json.decode(response.body)['data'];
      jwtToken="123456";
      print("JWD Token is that: ${jwtToken}");
      print("user id: ${userId}");

      saveToken();
      saveNumber();
      // print("id:"+ id);
      // saveId(id);

      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => HomeScreen()));
    } catch (error) {
      print(error);
    }
  }

  saveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Token", jwtToken);
  }

  saveNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Number", phoneNumber);
  }

  numberValidation() async {
    try {
      var map = Map<String, dynamic>();
      map['user_number'] = phoneNumber;
    //  map['sessionInfo'] = user_id;

      http.Response response = await http.post(
        Uri.parse(
          'https://auth.azscrap.com/api/user/validate-phone-number',
        ),
        headers: {
          "x-access-token": jwtToken,
        },
        body: map,
        // body:  json.encode({
        //   'phoneNumber': "0383748377",
        //   'sessionInfo': "this is token info",
        // }),
      );
      // print("number validation");
      // print(response.body);
      // print(json.decode(response.body)['statusMsg']);
      // print(json.decode(response.body)['data']);
      // print(user_id);
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
      child: FirebasePhoneAuthHandler(
        phoneNumber: phoneNumber,
        otpExpirationDuration: const Duration(seconds: 60),
        onLoginSuccess: (userCredential, autoVerified) async {
          _showSnackBar(
            context,
            'Phone number verified successfully!',
          );

          debugPrint(
            autoVerified
                ? "OTP was fetched automatically"
                : "OTP was verified manually",
          );

          debugPrint("Login Success UID: ${userCredential.user?.uid}");
          userId = userCredential.user?.uid;
          Provider.of<UserProvider>(context, listen: false).Adduser(
            UserModel(
              // user_id: phoneNumber,
              user_id: userId,
              user_number: phoneNumber,
              is_registered: false,
            ),
          );
          // FutureBuilder(
          //   future: number_authentication(),
          //   builder: (context, snapshot){
          //     if (snapshot.hasData){
          //       return number_validation();
          //
          //     }else{
          //       return CircularProgressIndicator();
          //     }
          //   },
          // );
          await numberAuthentication();
          await numberValidation();
          await Provider.of<UserProvider>(context, listen: false)
              .FetchUser(phoneNumber, jwtToken);
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MyNavigationBar(
                      jwtToken: jwtToken,
                      number: phoneNumber,
                      index: 0,
                    )));
          });
        },
        onLoginFailed: (authException, stackTrace) {
          _showSnackBar(
            context,
            'Something went wrong (${authException.message})',
          );

          debugPrint(authException.message);
          // handle error further if needed
        },
        builder: (context, controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Verify Phone Number"),
              backgroundColor: const Color(0xFF4071B6),
              actions: [
                if (controller.codeSent)
                  TextButton(
                    onPressed: !controller.isOtpExpired
                        ? null
                        : () async => await controller.sendOTP(),
                    child: Text(
                      !controller.isOtpExpired
                          ? "${controller.otpExpirationTimeLeft.inSeconds}s"
                          : "RESEND",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                const SizedBox(width: 5),
              ],
            ),
            body: controller.codeSent
                ? ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(
                        "We will sent an SMS with a verification code to $phoneNumber",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // const Divider(),
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        height: !controller.isOtpExpired ? null : 0,
                        child: const Column(
                          children: [
                            SpinKitCircle(
                              size: 70,
                              color: Colors.redAccent,
                            ),
                            // CircularProgressIndicator.adaptive(),
                            SizedBox(height: 50),
                            Text(
                              "Auto Verifying",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text("OR", textAlign: TextAlign.center),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "Enter OTP",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          letterSpacing: 5,
                        ),
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                        onChanged: (String v) async {
                          _enteredOTP = v;
                          if (_enteredOTP?.length == 6) {
                            final isValidOTP = await controller.verifyOtp(
                              _enteredOTP!,
                            );
                            // Incorrect OTP
                            if (!isValidOTP) {
                              _showSnackBar(
                                context,
                                "Please enter the correct OTP sent to $phoneNumber",
                              );
                            }
                          }
                        },
                      ),
                    ],
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SpinKitWanderingCubes(
                        size: 85,
                        color: Color(0xFF4071B6),
                      ),
                      SizedBox(height: 50),
                      Center(
                        child: Text(
                          "Sending OTP",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
