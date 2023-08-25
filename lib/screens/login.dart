// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../Auth/VerifyPhoneNumberScreen.dart';
import '../constants.dart';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String userNumber = "";
  String countryCode = "+971";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4071B6),
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Text(
              "Login With\nPhone Number",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.13,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.87,
              child: Text(
                "Enter Phone Number",
                style: TextStyle(fontSize: 18, color: Colors.black45),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  // controller: user_number,
                  // initialValue: "+971",
                  onSaved: (value) {
                    userNumber = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Phone Number';
                    }
                    return null;
                  },
                  maxLines: 1,
                  minLines: 1,
                  autofocus: false,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    prefixIcon: CountryCodePicker(
                      onChanged: (value) {

                        countryCode = value.toString();
                      },
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: '+971',
                      textStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      // favorite: ['+971','AE'],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      showFlag: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed: false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.sp, vertical: 12.sp),
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  userNumber = countryCode + userNumber;
                  Navigator.of(context).pushReplacement(
                      // MaterialPageRoute(builder: (context) => OtpVerify(number: user_number.text,)));
                      MaterialPageRoute(
                          builder: (context) => VerifyOtpScreen(
                              phoneNumber: userNumber)));
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Text(
                  'next'.toUpperCase(),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
