// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../Provider/User Provider.dart';
import '../constants.dart';
import 'about_us.dart';
import 'complete_profile.dart';
import 'contactUs.dart';
import 'edit_user.dart';
import 'login.dart';
import 'sold.dart';
import 'terms_conditions.dart';
import 'user_detail_screen.dart';

class Profile extends StatefulWidget {
  final String JWToken;
  final String Number;

  const Profile({Key? key, required this.JWToken, required this.Number})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);
    final user = userData.items;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF4271B7),
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          leading: Text(''),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Text(
                  // user[0].user_name.toString(),
                  user[0].is_registered
                      ? user[0].user_name.toString()
                      : "User Name",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (user[0].is_registered == false) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CompleteProfile(
                                user_number: user[0].user_number,
                                JWToken: widget.JWToken,
                              )));
                    } else if (user[0].verified == false) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditUser(
                                JWToken: widget.JWToken,
                              )));
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserDetail()));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(
                      user[0].verified ? "Verified" : "Unverified",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      user[0].verified ? Color(0xFF4271B7) : Colors.red,
                    ),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Sold()));
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFF1F2F3),
                        border: Border.all(color: Color(0xFFD1D3D4), width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sold',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700]),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey[700],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 10),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => Settings()));
                //   },
                //   child: Container(
                //     height: 50,
                //     width: MediaQuery.of(context).size.width / 1.1,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(15),
                //         color: Color(0xFFF1F2F3),
                //         border: Border.all(color: Color(0xFFD1D3D4), width: 1)),
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             'Settings',
                //             style: TextStyle(
                //                 fontSize: 18, color: Colors.grey[700]),
                //           ),
                //           Icon(
                //             Icons.arrow_forward_ios,
                //             size: 14,
                //             color: Colors.grey[700],
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AboutUs()));
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFF1F2F3),
                        border: Border.all(color: Color(0xFFD1D3D4), width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'About Us',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700]),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey[700],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TermsConditions()));
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFF1F2F3),
                        border: Border.all(color: Color(0xFFD1D3D4), width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Terms & Condition',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700]),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey[700],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => contact_Us()));
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFF1F2F3),
                      border: Border.all(color: Color(0xFFD1D3D4), width: 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Contact Us',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700]),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey[700],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    await preferences.clear();
                    await FirebasePhoneAuthHandler.signOut(context);
                    await Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                        (route) => false);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      kPrimaryColor,
                    ),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 23),
                    child: Text(
                      'logout'.toUpperCase(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
