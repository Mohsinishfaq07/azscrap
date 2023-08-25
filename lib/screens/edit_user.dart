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

class EditUser extends StatefulWidget {
  final String JWToken;

  const EditUser({Key? key, required this.JWToken}) : super(key: key);
  // final String user_number;

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  // String E_id_expiry = "";
  // String license_expiry2 = "";
  DateTime selectedDate = DateTime.now();
  DateTime license_expiry = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String Response = "";
  File? IdFront_img;
  String? IdFront_url;
  File? IdBack_img;
  String? IdBack_url;
  File? TradLicense_img;
  String? license_url;
  String Number = "";
  File? TRN_img;
  String? Trn_url;
  bool front_img_chek = false;
  bool back_img_chek = false;
  bool license_img_chek = false;
  bool trn_img_chek = false;
  bool Verify = true;
  bool is_loading = false;
  bool image_loading = false;
  bool image2_loading = false;
  bool image3_loading = false;
  bool image4_loading = false;
  var ref;
  var IdBack;
  var lincense;
  var Trn;
  var _edited_user = UserModel(
      user_id: null,
      user_number: "",
      user_name: "",
      user_email: "",
      company: "",
      emirates_id_front: "",
      emirates_id_back: "",
      emirate_id_expiry_date: "",
      trade_license_number: "",
      trade_license_image: "",
      trade_license_expiry_date: "",
      trn_number: "",
      trn_number_image: "",
      verified: false,
      is_registered: false);

  @override
  void didChangeDependencies() {
    _edited_user = Provider.of<UserProvider>(context, listen: false).findById();
    setState(() {
      Number = _edited_user.user_number;
      selectedDate = DateTime.parse(_edited_user.emirate_id_expiry_date!);
      // license_expiry2  = _edited_user.trade_license_expiry_date!;
      license_expiry = DateTime.parse(_edited_user.trade_license_expiry_date!);
    });
    img_paths();
  }

  img_paths() {
    // ref = FirebaseStorage.instance.ref().child("User_Images").child('${widget.user_number}').child('IdFront_img.jpg');
    ref = FirebaseStorage.instance
        .ref()
        .child("User_Images")
        .child('${Number}')
        .child('IdFront_img.jpg');
    IdBack = FirebaseStorage.instance
        .ref()
        .child("User_Images")
        .child('${Number}')
        .child("IdBack_img.jpg");
    lincense = FirebaseStorage.instance
        .ref()
        .child("User_Images")
        .child('${Number}')
        .child("TradLicense_img.jpg");
    Trn = FirebaseStorage.instance
        .ref()
        .child("User_Images")
        .child('${Number}')
        .child("TRN_img.jpg");
  }

  pickImage(ImageSource imageType) async {
    setState(() {
      image_loading = true;
    });
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        IdFront_img = tempImage;
        front_img_chek = false;
        // img_chek = false;
      });
      await ref.putFile(IdFront_img!);
      IdFront_url = await ref.getDownloadURL();
      setState(() {
        _edited_user.emirates_id_front = IdFront_url;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
    setState(() {
      image_loading = false;
    });
  }

  pickImage2(ImageSource imageType) async {
    setState(() {
      image2_loading = true;
    });
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        IdBack_img = tempImage;
        back_img_chek = false;
        // img_chek = false;
      });
      await IdBack.putFile(IdBack_img!);
      IdBack_url = await IdBack.getDownloadURL();
      _edited_user.emirates_id_back = IdBack_url;
    } catch (error) {
      debugPrint(error.toString());
    }
    setState(() {
      image2_loading = false;
    });
  }

  pickImage3(ImageSource imageType) async {
    setState(() {
      image3_loading = true;
    });
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        TradLicense_img = tempImage;
        license_img_chek = false;
      });
      await lincense.putFile(TradLicense_img!);
      license_url = await lincense.getDownloadURL();
      _edited_user.trade_license_image = license_url;
    } catch (error) {
      debugPrint(error.toString());
    }
    setState(() {
      image3_loading = false;
    });
  }

  pickImage4(ImageSource imageType) async {
    setState(() {
      image4_loading = true;
    });
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        TRN_img = tempImage;
        trn_img_chek = false;
      });
      await Trn.putFile(TRN_img!);
      Trn_url = await Trn.getDownloadURL();
      _edited_user.trn_number_image = Trn_url;
    } catch (error) {
      debugPrint(error.toString());
    }
    setState(() {
      image4_loading = true;
    });
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
        _edited_user.emirate_id_expiry_date =
            DateFormat("yyyy-MM-dd").format(selectedDate);
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
        _edited_user.trade_license_expiry_date =
            DateFormat("yyyy-MM-dd").format(license_expiry);
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
    final userData = Provider.of<UserProvider>(context);
    final user = userData.items;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF4271B7),
          title: Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
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
                    )),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              initialValue: _edited_user.user_name,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _edited_user = UserModel(
                                  user_id: _edited_user.user_id,
                                  user_number: _edited_user.user_number,
                                  user_name: value,
                                  user_email: _edited_user.user_email,
                                  company: _edited_user.company,
                                  emirates_id_front:
                                      _edited_user.emirates_id_front,
                                  emirates_id_back:
                                      _edited_user.emirates_id_back,
                                  emirate_id_expiry_date:
                                      _edited_user.emirate_id_expiry_date,
                                  trade_license_number:
                                      _edited_user.trade_license_number,
                                  trade_license_image:
                                      _edited_user.trade_license_image,
                                  trade_license_expiry_date:
                                      _edited_user.trade_license_expiry_date,
                                  trn_number: _edited_user.trn_number,
                                  trn_number_image:
                                      _edited_user.trn_number_image,
                                  verified: _edited_user.verified,
                                  is_registered: _edited_user.is_registered,
                                );
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
                              initialValue: _edited_user.user_email,
                              maxLines: 1,
                              minLines: 1,
                              autofocus: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email Address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _edited_user = UserModel(
                                  user_id: _edited_user.user_id,
                                  user_number: _edited_user.user_number,
                                  user_name: _edited_user.user_name,
                                  user_email: value,
                                  company: _edited_user.company,
                                  emirates_id_front:
                                      _edited_user.emirates_id_front,
                                  emirates_id_back:
                                      _edited_user.emirates_id_back,
                                  emirate_id_expiry_date:
                                      _edited_user.emirate_id_expiry_date,
                                  trade_license_number:
                                      _edited_user.trade_license_number,
                                  trade_license_image:
                                      _edited_user.trade_license_image,
                                  trade_license_expiry_date:
                                      _edited_user.trade_license_expiry_date,
                                  trn_number: _edited_user.trn_number,
                                  trn_number_image:
                                      _edited_user.trn_number_image,
                                  verified: _edited_user.verified,
                                  is_registered: _edited_user.is_registered,
                                );
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
                              initialValue: _edited_user.company,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter company name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _edited_user = UserModel(
                                  user_id: _edited_user.user_id,
                                  user_number: _edited_user.user_number,
                                  user_name: _edited_user.user_name,
                                  user_email: _edited_user.user_email,
                                  company: value,
                                  emirates_id_front:
                                      _edited_user.emirates_id_front,
                                  emirates_id_back:
                                      _edited_user.emirates_id_back,
                                  emirate_id_expiry_date:
                                      _edited_user.emirate_id_expiry_date,
                                  trade_license_number:
                                      _edited_user.trade_license_number,
                                  trade_license_image:
                                      _edited_user.trade_license_image,
                                  trade_license_expiry_date:
                                      _edited_user.trade_license_expiry_date,
                                  trn_number: _edited_user.trn_number,
                                  trn_number_image:
                                      _edited_user.trn_number_image,
                                  verified: _edited_user.verified,
                                  is_registered: _edited_user.is_registered,
                                );
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
                              height: 18,
                            ),
                            TextFormField(
                              initialValue: _edited_user.trade_license_number,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Trade License Number';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _edited_user = UserModel(
                                  user_id: _edited_user.user_id,
                                  user_number: _edited_user.user_number,
                                  user_name: _edited_user.user_name,
                                  user_email: _edited_user.user_email,
                                  company: _edited_user.company,
                                  emirates_id_front:
                                      _edited_user.emirates_id_front,
                                  emirates_id_back:
                                      _edited_user.emirates_id_back,
                                  emirate_id_expiry_date:
                                      _edited_user.emirate_id_expiry_date,
                                  trade_license_number: value,
                                  trade_license_image:
                                      _edited_user.trade_license_image,
                                  trade_license_expiry_date:
                                      _edited_user.trade_license_expiry_date,
                                  trn_number: _edited_user.trn_number,
                                  trn_number_image:
                                      _edited_user.trn_number_image,
                                  verified: _edited_user.verified,
                                  is_registered: _edited_user.is_registered,
                                );
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
                              height: 18,
                            ),
                            TextFormField(
                              initialValue: _edited_user.trn_number,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter TRN Number';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _edited_user = UserModel(
                                  user_id: _edited_user.user_id,
                                  user_number: _edited_user.user_number,
                                  user_name: _edited_user.user_name,
                                  user_email: _edited_user.user_email,
                                  company: _edited_user.company,
                                  emirates_id_front:
                                      _edited_user.emirates_id_front,
                                  emirates_id_back:
                                      _edited_user.emirates_id_back,
                                  emirate_id_expiry_date:
                                      _edited_user.emirate_id_expiry_date,
                                  trade_license_number:
                                      _edited_user.trade_license_number,
                                  trade_license_image:
                                      _edited_user.trade_license_image,
                                  trade_license_expiry_date:
                                      _edited_user.trade_license_expiry_date,
                                  trn_number: value,
                                  trn_number_image:
                                      _edited_user.trn_number_image,
                                  verified: _edited_user.verified,
                                  is_registered: _edited_user.is_registered,
                                );
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
                                child: _edited_user.emirates_id_front != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              _edited_user.emirates_id_front
                                                  .toString(),
                                              width: 282,
                                              height: 128,
                                              fit: BoxFit.fill,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _edited_user
                                                              .emirates_id_front =
                                                          null;
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
                                    : image_loading
                                        ? SpinKitCircle(
                                            size: 65,
                                            color: kPrimaryColor,
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
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: Center(
                                                        child: IconButton(
                                                          onPressed: () =>
                                                              showDialog<
                                                                  String>(
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
                                                                  EdgeInsets
                                                                      .zero,
                                                              content:
                                                                  Container(
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
                                                                            ImageSource.gallery);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'From Gallery',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          1.5,
                                                                      width:
                                                                          150,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        await pickImage(
                                                                            ImageSource.camera);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          'From Camera',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Icon(
                                                            Icons.add,
                                                            color:
                                                                Colors.black45,
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
                                child: _edited_user.emirates_id_back != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              _edited_user.emirates_id_back
                                                  .toString(),
                                              width: 282,
                                              height: 128,
                                              fit: BoxFit.fill,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _edited_user
                                                              .emirates_id_back =
                                                          null;
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
                                    : image2_loading
                                        ? SpinKitCircle(
                                            size: 65,
                                            color: kPrimaryColor,
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
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: Center(
                                                        child: IconButton(
                                                          onPressed: () =>
                                                              showDialog<
                                                                  String>(
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
                                                                  EdgeInsets
                                                                      .zero,
                                                              content:
                                                                  Container(
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
                                                                            ImageSource.gallery);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'From Gallery',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          1.5,
                                                                      width:
                                                                          150,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        pickImage2(
                                                                            ImageSource.camera);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          'From Camera',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Icon(
                                                            Icons.add,
                                                            color:
                                                                Colors.black45,
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
                                              _edited_user
                                                  .emirate_id_expiry_date
                                                  .toString(),
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
                                child: _edited_user.trade_license_image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              _edited_user.trade_license_image!,
                                              width: 282,
                                              height: 128,
                                              fit: BoxFit.fill,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _edited_user
                                                              .trade_license_image =
                                                          null;
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
                                    : image3_loading
                                        ? SpinKitCircle(
                                            size: 65,
                                            color: kPrimaryColor,
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
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: Center(
                                                        child: IconButton(
                                                          onPressed: () =>
                                                              showDialog<
                                                                  String>(
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
                                                                  EdgeInsets
                                                                      .zero,
                                                              content:
                                                                  Container(
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
                                                                            ImageSource.gallery);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'From Gallery',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          1.5,
                                                                      width:
                                                                          150,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        pickImage3(
                                                                            ImageSource.camera);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          'From Camera',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Icon(
                                                            Icons.add,
                                                            color:
                                                                Colors.black45,
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
                                            "Your Trade License is Expired",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey[500]),
                                          )
                                        : Text(
                                            _edited_user
                                                .trade_license_expiry_date
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                  ),
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
                                child: _edited_user.trn_number_image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              _edited_user.trn_number_image!,
                                              width: 282,
                                              height: 128,
                                              fit: BoxFit.fill,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _edited_user
                                                              .trn_number_image =
                                                          null;
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
                                    : image4_loading
                                        ? SpinKitCircle(
                                            size: 65,
                                            color: kPrimaryColor,
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
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: Center(
                                                        child: IconButton(
                                                          onPressed: () =>
                                                              showDialog<
                                                                  String>(
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
                                                                  EdgeInsets
                                                                      .zero,
                                                              content:
                                                                  Container(
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
                                                                            ImageSource.gallery);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'From Gallery',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          1.5,
                                                                      width:
                                                                          150,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        pickImage4(
                                                                            ImageSource.camera);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          'From Camera',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Icon(
                                                            Icons.add,
                                                            color:
                                                                Colors.black45,
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
                            if (_edited_user.emirates_id_front == null) {
                              setState(() {
                                front_img_chek = true;
                              });
                            }
                            if (_edited_user.emirates_id_back == null) {
                              setState(() {
                                back_img_chek = true;
                              });
                            }
                            if (_edited_user.trade_license_image == null) {
                              setState(() {
                                license_img_chek = true;
                              });
                            }
                            if (_edited_user.trn_number_image == null) {
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
                              _formKey.currentState!.save();
                              Response = await Provider.of<UserProvider>(
                                      context,
                                      listen: false)
                                  .EditUser(
                                _edited_user,
                                widget.JWToken,
                              );
                              setState(() {
                                is_loading = false;
                              });
                              await _displaySnackBar(context);
                              Future.delayed(const Duration(seconds: 3), () {
                                Navigator.pop(context);
                              });
                              // Navigator.of(context).pushReplacementNamed(Home.routeName, arguments: true);
                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyNavigationBar(index: 0,)));
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
