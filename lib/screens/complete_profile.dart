// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../Provider/User Provider.dart';
import '../constants.dart';
import '../model/User_model.dart';

class CompleteProfile extends StatefulWidget {
  final String user_number;
  final String JWToken;

  const CompleteProfile({
    Key? key,
    required this.user_number,
    required this.JWToken,
  }) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  String E_id_expiry = "";
  String license_expiry2 = "";
  String Response = "";
  DateTime selectedDate = DateTime.now();
  DateTime license_expiry = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  TextEditingController user_name = TextEditingController();
  TextEditingController user_email = TextEditingController();
  TextEditingController user_company = TextEditingController();
  TextEditingController trade_license_number = TextEditingController();
  TextEditingController trn_number = TextEditingController();
  // TextEditingController emirates_id_expiry_date = TextEditingController();
  // TextEditingController trade_license_expiry_date = TextEditingController();

  File? IdFront_img;
  String? IdFront_url;
  File? IdBack_img;
  String? IdBack_url;
  File? TradLicense_img;
  String? license_url;
  File? TRN_img;
  String? Trn_url;
  bool front_img_chek = false;
  bool back_img_chek = false;
  bool license_img_chek = false;
  bool trn_img_chek = false;
  bool Verify = true;
  bool is_loading = false;
  var ref;
  var IdBack;
  var lincense;
  var Trn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref = FirebaseStorage.instance
        .ref()
        .child("User_Images")
        .child('${widget.user_number}')
        .child('IdFront_img.jpg');
    IdBack = FirebaseStorage.instance
        .ref()
        .child("User_Images")
        .child('${widget.user_number}')
        .child("IdBack_img.jpg");
    lincense = FirebaseStorage.instance
        .ref()
        .child("User_Images")
        .child('${widget.user_number}')
        .child("TradLicense_img.jpg");
    Trn = FirebaseStorage.instance
        .ref()
        .child("User_Images")
        .child('${widget.user_number}')
        .child("TRN_img.jpg");
  }

  // user_registration() async {
  //    is_loading = true;
  //    try{
  //      var map = new Map<String, dynamic>();
  //      map['user_number'] = widget.user_number;
  //      map['user_name'] = user_name.text;
  //      map['user_email'] = user_email.text;
  //      map['company'] = user_company.text;
  //      map['emirates_id_front'] = IdFront_url;
  //      map['emirates_id_back'] = IdBack_url;
  //      map['emirate_id_expiry_date'] = E_id_expiry;
  //      map['trade_license'] = license_url;
  //      map['trade_license_expiry_date'] = license_expiry2;
  //      map['trn_number'] = Trn_url;
  //     // map['verified'] = "true";
  //
  //      http.Response response = await http.post(
  //        Uri.parse('http://192.168.10.5:3001/api/user/user-registration'),
  //        headers: {
  //          "x-access-token": JWDToken!,
  //        },
  //        body: map,
  //        // body:  json.encode({
  //        //   'phoneNumber': "0383748377",
  //        //   'sessionInfo': "this is token info",
  //        // }),
  //      );
  //      print(response.body);
  //      print(json.decode(response.body)['statusMsg']);
  //      print(json.decode(response.body)['data']);
  //      // print("id:"+ id);
  //      // saveId(id);
  //
  //      // Navigator.of(context).pushReplacement(MaterialPageRoute(
  //      //     builder: (context) => HomeScreen()));
  //    }
  //    catch(error){
  //      print(error);
  //    }
  //    is_loading = false;
  //  }

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        IdFront_img = tempImage;
        front_img_chek = false;
        // img_chek = false;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  pickImage2(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        IdBack_img = tempImage;
        back_img_chek = false;
        // img_chek = false;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  pickImage3(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        TradLicense_img = tempImage;
        license_img_chek = false;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  pickImage4(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        TRN_img = tempImage;
        trn_img_chek = false;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        E_id_expiry = DateFormat("yyyy-MM-dd").format(selectedDate);
      });
  }

  _selectLicenseExpiry(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: license_expiry,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        license_expiry = selected;
        license_expiry2 = DateFormat("yyyy-MM-dd").format(license_expiry);
      });
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.fixed,
        content: Text(
          Response,
          style: TextStyle(color: Colors.blue, fontSize: 14.sp),
          textAlign: TextAlign.center,
        ));
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF4271B7),
          title: Text(
            "Complete Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                // Provider.of <UserProvider>(context, listen: false).Addnumber(
                //   UserModel(user_id: null,
                //     user_number: widget.user_number,
                //     verified: false,
                //   )
                // );
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyNavigationBar(index: 0,)));
              },
              // Navigator.of(context).pushReplacementNamed(Home.routeName, arguments: false,),
              icon: Icon(Icons.close),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: is_loading
                ? Container(
                    height: 100.h,
                    width: 100.w,
                    child: Center(
                        child: SpinKitCircle(
                      size: 65,
                      color: kPrimaryColor,
                    )))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   'Name:',
                            //   textAlign: TextAlign.start,
                            //   style: TextStyle(fontSize: 18, color: Colors.black),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: user_name,
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
                                  "Name",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[500]),
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
                            SizedBox(
                              height: 10,
                            ),
                            // Text(
                            //   'Email:',
                            //   textAlign: TextAlign.start,
                            //   style: TextStyle(fontSize: 18, color: Colors.black),
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: user_email,
                              maxLines: 1,
                              minLines: 1,
                              autofocus: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email Address';
                                }
                                return null;
                              },
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                label: Text(
                                  "Email",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[500]),
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
                            SizedBox(
                              height: 10,
                            ),
                            // Text(
                            //   'Company:',
                            //   textAlign: TextAlign.start,
                            //   style: TextStyle(fontSize: 18, color: Colors.black),
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: user_company,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter company name';
                                }
                                return null;
                              },
                              maxLines: 1,
                              minLines: 1,
                              autofocus: false,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                label: Text(
                                  "Company",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[500]),
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
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: trade_license_number,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Trade License Number';
                                }
                                return null;
                              },
                              maxLines: 1,
                              minLines: 1,
                              autofocus: false,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                label: Text(
                                  "Trade License Number",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[500]),
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
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: trn_number,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter TRN Number';
                                }
                                return null;
                              },
                              maxLines: 1,
                              minLines: 1,
                              autofocus: false,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                label: Text(
                                  "TRN Number",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[500]),
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
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Emirates ID Front:',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[500]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Container(
                                height: 130,
                                width: 280,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 2, color: Colors.grey),
                                ),
                                child: IdFront_img != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          children: [
                                            Image.file(
                                              IdFront_img!,
                                              width: 282,
                                              height: 128,
                                              fit: BoxFit.fill,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      IdFront_img = null;
                                                    });
                                                  },
                                                  icon: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: Icon(
                                                        Icons.clear,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ))),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Material(
                                              elevation: 0,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: Center(
                                                    child: IconButton(
                                                      onPressed: () =>
                                                          showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          content: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.15,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    pickImage(
                                                                        ImageSource
                                                                            .gallery);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'From Gallery',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 1.5,
                                                                  width: 150,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    pickImage(
                                                                        ImageSource
                                                                            .camera);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'From Camera',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            18,
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.zero,
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: Colors.black45,
                                                        size: 42,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            // Text("UPLOAD or Drag\nProduct Image",
                                            //   style: TextStyle(color: Colors.black38,
                                            //       fontSize: 20,
                                            //       fontWeight: FontWeight.w600),
                                            // ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            if (front_img_chek == true)
                              Center(
                                child: Container(
                                  child: Text(
                                    "Please add Emirates ID Front image",
                                    style: TextStyle(
                                        color: Colors.red, height: 1.5),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Emirates ID Back:',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[500]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Container(
                                height: 130,
                                width: 280,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 2, color: Colors.grey),
                                ),
                                child: IdBack_img != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          children: [
                                            Image.file(
                                              IdBack_img!,
                                              width: 282,
                                              height: 128,
                                              fit: BoxFit.fill,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      IdBack_img = null;
                                                    });
                                                  },
                                                  icon: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: Icon(
                                                        Icons.clear,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ))),
                                            ),
                                          ],
                                        ))
                                    : Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Material(
                                              elevation: 0,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: Center(
                                                    child: IconButton(
                                                      onPressed: () =>
                                                          showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          content: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.15,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    pickImage2(
                                                                        ImageSource
                                                                            .gallery);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'From Gallery',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 1.5,
                                                                  width: 150,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    pickImage2(
                                                                        ImageSource
                                                                            .camera);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'From Camera',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            18,
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.zero,
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: Colors.black45,
                                                        size: 42,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            // Text("UPLOAD or Drag\nProduct Image",
                                            //   style: TextStyle(color: Colors.black38,
                                            //       fontSize: 20,
                                            //       fontWeight: FontWeight.w600),
                                            // ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            if (back_img_chek == true)
                              Center(
                                child: Container(
                                  child: Text(
                                    "Please add back image of Emirates ID",
                                    style: TextStyle(
                                        color: Colors.red, height: 1.5),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            // Text(
                            //   'Emirate ID Expiry Date:',
                            //   textAlign: TextAlign.start,
                            //   style: TextStyle(fontSize: 18, color: Colors.black),
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Emirates ID Expiry Date",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black45),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      child: selectedDate.year ==
                                                  DateTime.now().year &&
                                              selectedDate.month ==
                                                  DateTime.now().month &&
                                              selectedDate.day ==
                                                  DateTime.now().day
                                          ? Text(
                                              "",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey[500]),
                                            )
                                          : Text(
                                              E_id_expiry,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            )),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      _selectDate(context);
                                      // setState(() {
                                      //
                                      // });
                                      print(selectedDate);
                                      print(selectedDate);
                                      print(selectedDate);
                                    },
                                    icon: Icon(
                                      Icons.date_range_outlined,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                ],
                              ),
                            ),
                            // TextFormField(
                            //   // controller: emirates_id_expiry_date,
                            //   keyboardType: TextInputType.number,
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Please enter emirate id expiry date';
                            //     }
                            //     return null;
                            //   },
                            //   maxLines: 1,
                            //   minLines: 1,
                            //   autofocus: false,
                            //   style: TextStyle(fontSize: 18),
                            //   // initialValue: Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}").toString(),
                            //   decoration: InputDecoration(
                            //     label: Text("Emirates ID Expiry Date",  style: TextStyle(fontSize: 18, color: Colors.grey[500]),),
                            //     filled: true,
                            //     fillColor: Colors.white,
                            //     enabledBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(15),
                            //       borderSide: BorderSide(color: Colors.grey),
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(15),
                            //       borderSide: BorderSide(color: Colors.blue),
                            //     ),
                            //     suffixIcon: IconButton(
                            //       onPressed: (){
                            //         _selectDate(context);
                            //       },
                            //       icon: Icon(Icons.date_range_outlined, size: 28,),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Trade License:',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[500]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Container(
                                height: 130,
                                width: 280,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 2, color: Colors.grey),
                                ),
                                child: TradLicense_img != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          children: [
                                            Image.file(
                                              TradLicense_img!,
                                              width: 282,
                                              height: 128,
                                              fit: BoxFit.fill,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      TradLicense_img = null;
                                                    });
                                                  },
                                                  icon: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: Icon(
                                                        Icons.clear,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ))),
                                            ),
                                          ],
                                        ))
                                    : Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Material(
                                              elevation: 0,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: Center(
                                                    child: IconButton(
                                                      onPressed: () =>
                                                          showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          content: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.15,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    pickImage3(
                                                                        ImageSource
                                                                            .gallery);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'From Gallery',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 1.5,
                                                                  width: 150,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    pickImage3(
                                                                        ImageSource
                                                                            .camera);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'From Camera',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            18,
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.zero,
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: Colors.black45,
                                                        size: 42,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            // Text("UPLOAD or Drag\nProduct Image",
                                            //   style: TextStyle(color: Colors.black38,
                                            //       fontSize: 20,
                                            //       fontWeight: FontWeight.w600),
                                            // ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            if (license_img_chek == true)
                              Center(
                                child: Container(
                                  child: Text(
                                    "Please add Trade License image",
                                    style: TextStyle(
                                        color: Colors.red, height: 1.5),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            // Text(
                            //   'Trade License Expiry Date:',
                            //   textAlign: TextAlign.start,
                            //   style: TextStyle(fontSize: 18, color: Colors.black),
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Trade License Expiry Date",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black45),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      child: license_expiry.year ==
                                                  DateTime.now().year &&
                                              license_expiry.month ==
                                                  DateTime.now().month &&
                                              license_expiry.day ==
                                                  DateTime.now().day
                                          ? Text(
                                              "",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey[500]),
                                            )
                                          : Text(
                                              license_expiry2,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            )),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      _selectLicenseExpiry(context);
                                    },
                                    icon: Icon(
                                      Icons.date_range_outlined,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                ],
                              ),
                            ),
                            // TextFormField(
                            //   controller: trade_license_expiry_date,
                            //   keyboardType: TextInputType.number,
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Please enter trade license expiry date';
                            //     }
                            //     return null;
                            //   },
                            //   maxLines: 1,
                            //   minLines: 1,
                            //   autofocus: false,
                            //   style: TextStyle(fontSize: 18),
                            //   decoration: InputDecoration(
                            //     label: Text("Trade License Expiry Date",  style: TextStyle(fontSize: 18, color: Colors.grey[500]),),
                            //     filled: true,
                            //     fillColor: Colors.white,
                            //     enabledBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(15),
                            //       borderSide: BorderSide(color: Colors.grey),
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(15),
                            //       borderSide: BorderSide(color: Colors.blue),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'TRN/TAX Number:',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[500]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Container(
                                height: 130,
                                width: 280,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 2, color: Colors.grey),
                                ),
                                child: TRN_img != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          children: [
                                            Image.file(
                                              TRN_img!,
                                              width: 282,
                                              height: 128,
                                              fit: BoxFit.fill,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      TRN_img = null;
                                                    });
                                                  },
                                                  icon: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: Icon(
                                                        Icons.clear,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ))),
                                            ),
                                          ],
                                        ))
                                    : Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Material(
                                              elevation: 0,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: Center(
                                                    child: IconButton(
                                                      onPressed: () =>
                                                          showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          content: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.15,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    pickImage4(
                                                                        ImageSource
                                                                            .gallery);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'From Gallery',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 1.5,
                                                                  width: 150,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    pickImage4(
                                                                        ImageSource
                                                                            .camera);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'From Camera',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            18,
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.zero,
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: Colors.black45,
                                                        size: 42,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            // Text("UPLOAD or Drag\nProduct Image",
                                            //   style: TextStyle(color: Colors.black38,
                                            //       fontSize: 20,
                                            //       fontWeight: FontWeight.w600),
                                            // ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            if (trn_img_chek == true)
                              Center(
                                child: Container(
                                  child: Text(
                                    "Please add TRN/TAX Number image",
                                    style: TextStyle(
                                        color: Colors.red, height: 1.5),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (IdFront_img == null) {
                              setState(() {
                                front_img_chek = true;
                              });
                            }
                            if (IdBack_img == null) {
                              setState(() {
                                back_img_chek = true;
                              });
                            }
                            if (TradLicense_img == null) {
                              setState(() {
                                license_img_chek = true;
                              });
                            }
                            if (TRN_img == null) {
                              setState(() {
                                trn_img_chek = true;
                              });
                            }
                            if (_formKey.currentState!.validate() &&
                                front_img_chek == false &&
                                back_img_chek == false &&
                                license_img_chek == false &&
                                trn_img_chek == false) {
                              setState(() {
                                is_loading = true;
                              });
                              await ref.putFile(IdFront_img!);
                              await IdBack.putFile(IdBack_img!);
                              await lincense.putFile(TradLicense_img!);
                              await Trn.putFile(TRN_img!);
                              IdFront_url = await ref.getDownloadURL();
                              IdBack_url = await IdBack.getDownloadURL();
                              license_url = await lincense.getDownloadURL();
                              Trn_url = await Trn.getDownloadURL();
                              print("The image url from firebase is that:");
                              print(IdFront_url);
                              Response = await Provider.of<UserProvider>(
                                      context,
                                      listen: false)
                                  .updateUser(
                                UserModel(
                                  user_id: widget.user_number,
                                  user_number: widget.user_number,
                                  user_name: user_name.text,
                                  user_email: user_email.text,
                                  company: user_company.text,
                                  emirates_id_front: IdFront_url,
                                  emirates_id_back: IdBack_url,
                                  emirate_id_expiry_date: E_id_expiry,
                                  trade_license_number:
                                      trade_license_number.text,
                                  trade_license_image: license_url,
                                  trade_license_expiry_date: license_expiry2,
                                  trn_number: trn_number.text,
                                  trn_number_image: Trn_url,
                                  is_registered: true,
                                ),
                                widget.JWToken,
                              );
                              setState(() {
                                is_loading = false;
                              });
                              await _displaySnackBar(context);
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              'Submit'.toUpperCase(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue[800]),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
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
