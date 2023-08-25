import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import '../PDF/pdfpreview.dart';
import '../Provider/Scrap Provider.dart';
import '../Provider/User Provider.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '../constants.dart';
import '../model/ChatRoomModel.dart';
import '../model/Scrap_model.dart';
import '../model/UserModel.dart';
import 'package:uuid/uuid.dart';

import '../model/fire_message_model.dart';

var uuid = Uuid();

class Chat extends StatefulWidget {
  final String? scrap_id;
  int inc;

  Chat({Key? key, required this.scrap_id, required this.inc}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ChatRoomModel? chatroomModel;
  // final _priceKey = GlobalKey<FormState>();
  TextEditingController Message = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final ImagePicker imagePicker = ImagePicker();
  // TextEditingController price = TextEditingController();
  bool is_sender = true;
  String number = "";
  String UserName = "User";
  String TradeLicense = "";
  String TrnNo = "";
  String chatResponse = "";
  String? JWDToken = "";
  String Chat_id = "";
  bool cheack = false;
  bool chat_loading = false;
  List<XFile>? imageFileList = [];
  List<File>? pdfFileList = [];
  bool image_loading = false;
  bool is_registred = false;
  var ref;
  Map attachment_url = {};
  // bool pdf_genrator = false;
  var _edited_scrap = ScrapModel(
    scrap_id: null,
    scrap_ctg: "",
    scrap_sub_ctg: "",
    // sub_ctg_icon: "",
    // scrap_title: "",
    scrap_description: "",
    scrap_weight: "0",
    // scrap_price: 0,
    phone_number: "0",
    scrap_images: [],
    scrap_city: "",
    scrap_address: "",
    is_accepted: false,
  );

  get_token() async {
    // String? Token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    JWDToken = prefs.getString("Token");
    // Token = JWDToken;
    print("The sahre-pref token is ${JWDToken}");
    // return Token;
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.fixed,
        content: Text(
          chatResponse,
          style: TextStyle(color: Colors.blue),
        ));
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  Select_Images() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    // Navigator.pop(context);
    setState(() {
      image_loading = true;
    });
    if (imageFileList != null) {
      // Map<int, String> image_urlMap = images_url.asMap();
      for (var i = 0; i < imageFileList!.length; i++) {
        ref = await FirebaseStorage.instance
            .ref()
            .child("Attachments (Images)")
            .child('${number}')
            .child('${DateTime.now()}_image_${i}.jpg');
        await ref.putFile(File(imageFileList![i].path));
        attachment_url[i] = await ref.getDownloadURL();
        imageFileList!.clear();
        print("Image Url No: ${i}: ");
        print(attachment_url[i]);
        // hashMap.set(`image${i}`, images_url[i])
        // initState() {
        //   // TODO: implement initState
        //   super.initState();
        //
        // }
      }
      // images_url = image_urlMap.values.toList();
    }
    setState(() {
      image_loading = false;
    });
  }

  Select_Pdf() async {
    // final List<XFile>? selectedImages = await
    // imagePicker.pickMultiImage();
    // if (selectedImages!.isNotEmpty) {
    //   imageFileList!.addAll(selectedImages);
    // }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      pdfFileList!.addAll(files);
    }
    // Navigator.pop(context);
    setState(() {
      image_loading = true;
    });
    if (pdfFileList != null) {
      // Map<int, String> image_urlMap = images_url.asMap();
      for (var i = 0; i < pdfFileList!.length; i++) {
        ref = await FirebaseStorage.instance
            .ref()
            .child("Attachments (Pdf)")
            .child('${number}')
            .child('${DateTime.now()}_image_${i}.pdf');
        await ref.putFile(File(pdfFileList![i].path));
        attachment_url[i] = await ref.getDownloadURL();
        pdfFileList!.clear();
        print("Image Url No: ${i}: ");
        print(attachment_url[i]);
        // hashMap.set(`image${i}`, images_url[i])
        // initState() {
        //   // TODO: implement initState
        //   super.initState();
        //
        // }
      }
      // images_url = image_urlMap.values.toList();
    }
    setState(() {
      image_loading = false;
    });
  }

  // Timer.periodic(Duration(seconds: 5), (timer) {
  // print(DateTime.now());
  // });

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.scrap_id}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.scrap_id.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      print("New Chatroom Created!");
    }

    return chatRoom;
  }

  void sendMessage() async {
    String msg = Message.text.trim();
    Message.clear();

    if (msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
          messageid: uuid.v1(),
          sender: widget.scrap_id,
          createdon: DateTime.now(),
          text: msg,
          seen: false);

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomModel!.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      chatroomModel!.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomModel!.chatroomid)
          .set(chatroomModel!.toMap());

      print("Message Sent!");
    }
  }

  void didChangeDependencies() async {
    final scrap_id = widget.scrap_id;
    if (scrap_id != null && widget.inc == 1) {
      setState(() {
        chat_loading = true;
      });
      chatroomModel = await getChatroomModel(UserModel(uid: "admin"));

      setState(() {
        _edited_scrap = Provider.of<ScrapProvider>(context, listen: false)
            .findById(scrap_id);
      });
      setState(() {
        chat_loading = false;
        widget.inc = 2;
      });
    }
  }

  void verification_dailogbox() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  // height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 5.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Sorry",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // SizedBox(height: 10.sp,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.sp),
                          child: Text(
                            'Your Account is not verified yet. Please wait for admin to verify you',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     ElevatedButton(
                        //       onPressed: () {
                        //         Navigator.pop(context);
                        //       },
                        //       child: Padding(
                        //         padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
                        //         child: Text(
                        //           'Later'.toUpperCase(),
                        //           style: TextStyle(fontSize: 20, color: Colors.white),
                        //         ),
                        //       ),
                        //       style: ButtonStyle(
                        //         backgroundColor: MaterialStateProperty.all(Colors.blue[800]),
                        //         foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        //           RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(25.0),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: 15,
                        //     ),
                        //     ElevatedButton(
                        //       onPressed: () {},
                        //       //   Navigator.pop(context);
                        //       //   Navigator.of(context).push(MaterialPageRoute(
                        //       //       builder: (context) => CompleteProfile(user_number: number,)));
                        //       // },
                        //       child: Padding(
                        //         padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
                        //         child: Text(
                        //           'Verify'.toUpperCase(),
                        //           style: TextStyle(fontSize: 20, color: Colors.white),
                        //         ),
                        //       ),
                        //       style: ButtonStyle(
                        //         backgroundColor: MaterialStateProperty.all(Colors.green[800]),
                        //         foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        //           RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(25.0),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  // void verification_dailogbox() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15.0),
  //           ),
  //           child: SizedBox(
  //             height: MediaQuery.of(context).size.height*0.25,
  //             child: Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               child: Container(
  //                 height: 150,
  //                 width: MediaQuery.of(context).size.width,
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(15), color: Colors.white),
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 20),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 10),
  //                         child: Text(
  //                           'Your Account is not verified yet',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                             fontSize: 23,
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 10,
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           ElevatedButton(
  //                             onPressed: () {
  //                               Navigator.pop(context);
  //                             },
  //                             child: Padding(
  //                               padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
  //                               child: Text(
  //                                 'Later'.toUpperCase(),
  //                                 style: TextStyle(fontSize: 20, color: Colors.white),
  //                               ),
  //                             ),
  //                             style: ButtonStyle(
  //                               backgroundColor: MaterialStateProperty.all(Colors.blue[800]),
  //                               foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  //                               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                                 RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(25.0),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             width: 15,
  //                           ),
  //                           ElevatedButton(
  //                             onPressed: () {
  //                               Navigator.pop(context);
  //                               Navigator.of(context).push(MaterialPageRoute(
  //                                   builder: (context) => CompleteProfile(user_number: number,)));
  //                             },
  //                             child: Padding(
  //                               padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
  //                               child: Text(
  //                                 'Verify'.toUpperCase(),
  //                                 style: TextStyle(fontSize: 20, color: Colors.white),
  //                               ),
  //                             ),
  //                             style: ButtonStyle(
  //                               backgroundColor: MaterialStateProperty.all(Colors.green[800]),
  //                               foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  //                               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                                 RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(25.0),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  void ateachment_dailogbox() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              title: SizedBox(
                height: 19.h,
                child: Padding(
                  padding: EdgeInsets.all(5.sp),
                  child: Container(
                    height: 18.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: image_loading
                          ? SpinKitFadingCircle(
                              color: Colors.blue,
                              size: 70,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Padding(
                                //   padding: EdgeInsets.symmetric(horizontal: 10),
                                //   child: Text(
                                //     'Your Account is not verified yet',
                                //     textAlign: TextAlign.center,
                                //     style: TextStyle(
                                //       fontSize: 16.sp,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // ),
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      image_loading = true;
                                    });
                                    await Select_Images();
                                    setState(() {
                                      image_loading = false;
                                      Navigator.pop(context);
                                    });
                                    Message.clear();
                                    _displaySnackBar(context);
                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.blueAccent
                                                  .withOpacity(0.3)),
                                          child: Image.asset(
                                              "assets/image_icon.png"),
                                        ),
                                        SizedBox(
                                          height: 4.sp,
                                        ),
                                        Text(
                                          "Images",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      image_loading = true;
                                    });
                                    await Select_Pdf();
                                    setState(() {
                                      image_loading = false;
                                      Navigator.pop(context);
                                    });
                                    Message.clear();
                                    _displaySnackBar(context);
                                    attachment_url.clear();
                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(10.0),
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.blueAccent
                                                    .withOpacity(0.3)),
                                            child: Image.asset(
                                                "assets/pdf_icon.png")),
                                        SizedBox(
                                          height: 4.sp,
                                        ),
                                        Text(
                                          "PDF",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  void deal_verification() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Do you want to accept this deal',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                //     builder: (context) => CompleteProfile(user_number: "123",)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 14),
                                child: Text(
                                  'No'.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green[800]),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                _edited_scrap = ScrapModel(
                                  scrap_id: _edited_scrap.scrap_id,
                                  scrap_ctg: _edited_scrap.scrap_ctg,
                                  scrap_sub_ctg: _edited_scrap.scrap_sub_ctg,
                                  // sub_ctg_icon: _edited_scrap.sub_ctg_icon,
                                  // scrap_title: _edited_scrap.scrap_title,
                                  scrap_description:
                                      _edited_scrap.scrap_description,
                                  scrap_weight: _edited_scrap.scrap_weight,
                                  // scrap_price: _edited_scrap.scrap_price,
                                  phone_number: _edited_scrap.phone_number,
                                  scrap_images: _edited_scrap.scrap_images,
                                  scrap_city: _edited_scrap.scrap_city,
                                  scrap_address: _edited_scrap.scrap_address,
                                  is_accepted: true,
                                );
                                setState(() {
                                  cheack = true;
                                });
                                await get_token();
                                await Provider.of<ScrapProvider>(context)
                                    .accept_scrap(widget.scrap_id!, JWDToken!);
                                // await Provider.of<ScrapProvider>(context, listen: false)
                                //      .UpdateScrap(widget.scrap_id, _edited_scrap, JWDToken!);
                                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Chat(scrap_id: widget.scrap_id) ));
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 14),
                                child: Text(
                                  'Yes'.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue[800]),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: chat_loading
          ? Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()))
          : Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: kPrimaryColor,
                title: _edited_scrap.scrap_ctg.isEmpty
                    ? SpinKitThreeBounce(
                        color: Colors.white,
                        size: 25,
                      )
                    : Text(
                        "${_edited_scrap.scrap_ctg} > ${_edited_scrap.scrap_sub_ctg}",
                        style: TextStyle(color: Colors.white),
                      ),
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                ),
                actions: [
                  _edited_scrap.scrap_images!.isEmpty
                      ? SpinKitThreeBounce(
                          color: Colors.white,
                          size: 20,
                        )
                      : Container(
                          height: 5.h,
                          width: 12.w,
                          margin: EdgeInsets.only(
                              top: 5.sp, bottom: 5.sp, right: 5.sp),
                          decoration: BoxDecoration(
                              // color: Colors.red
                              ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(150),
                              child: Image.network(
                                _edited_scrap.scrap_images![0],
                                fit: BoxFit.fill,
                              )),
                        ),
                ],
              ),
              body: SafeArea(
                child: Container(
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                  // child: SingleChildScrollView(
                  //   scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 9.h,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[300]),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Consumer<ScrapProvider>(
                                      builder: (ctx, accepted, child) =>
                                          ElevatedButton(
                                        onPressed: () {
                                          if (_edited_scrap.scrap_price > 0) {
                                            if (Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .items[0]
                                                    .verified ==
                                                true) {
                                              if (_edited_scrap.is_accepted ==
                                                  false) deal_verification();
                                            } else {
                                              verification_dailogbox();
                                            }
                                          }
                                          // accepted.accept_deal();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 7),
                                          child: Text(
                                            _edited_scrap.is_accepted
                                                ? 'accepted'.toUpperCase()
                                                : 'accept'.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all(_edited_scrap.scrap_price > 0
                                                  ? _edited_scrap.is_accepted
                                                      ? Colors.grey
                                                      : Colors.green[700]
                                                  : Colors.grey),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  // color: Colors.blue,
                                  child: Text(
                                    "${_edited_scrap.scrap_price} AED",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: _edited_scrap.scrap_price > 0
                                            ? Colors.green
                                            : Colors.black,
                                        decoration: null),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'This is the begining of your chat',
                        style: TextStyle(color: Colors.black, fontSize: 19),
                      ),
                      SizedBox(
                        height: 2.sp,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("chatrooms")
                                  .doc(chatroomModel!.chatroomid)
                                  .collection("messages")
                                  .orderBy("createdon", descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.active) {
                                  if (snapshot.hasData) {
                                    QuerySnapshot dataSnapshot =
                                        snapshot.data as QuerySnapshot;

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      reverse: true,
                                      itemCount: dataSnapshot.docs.length,
                                      itemBuilder: (context, index) {
                                        MessageModel currentMessage =
                                            MessageModel.fromMap(
                                                dataSnapshot.docs[index].data()
                                                    as Map<String, dynamic>);

                                        return Row(
                                          mainAxisAlignment:
                                              (currentMessage.sender !=
                                                      UserModel(
                                                          uid: widget.scrap_id))
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 2,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: (currentMessage
                                                              .sender ==
                                                          UserModel(
                                                              uid: widget
                                                                  .scrap_id))
                                                      ? Colors.grey
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                child: Text(
                                                  currentMessage.text
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                  ),
                                                )),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                          "An error occured! Please check your internet connection."),
                                    );
                                  } else {
                                    return Center(
                                      child: Text(""),
                                    );
                                  }
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      // Spacer(),
                      if (_edited_scrap.is_accepted == true || cheack == true)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PdfPreviewPage(),
                              ),
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.11,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  // color: Colors.blue,
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Image.asset(
                                    "assets/pdf-icon.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  "Seller's Contract",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 1.h,
                      ),
                      // SizedBox(height: MediaQuery.of(context).size.height*0.43,),
                      // BottomNavigationSend(),
                      Container(
                        height: 70,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.3,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: TextField(
                                          autofocus: false,
                                          cursorColor: Colors.blue,
                                          controller: Message,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: ' Type Here',
                                            // icon: Image.asset('assets/emoji.png', height: 25, width: 25,),
                                            suffixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    ateachment_dailogbox();
                                                  },
                                                  icon: Icon(
                                                    Icons.attach_file_rounded,
                                                    color: Colors.blue,
                                                    size: 18.sp,
                                                  )),
                                              // child: Image.asset('assets/file.png', height: 15, width: 15,),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: IconButton(
                                          onPressed: () async {
                                            sendMessage();
                                          },
                                          icon: Icon(
                                            Icons.send,
                                            color: Colors.blue,
                                            size: 30,
                                          ),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ),
                ),
              ),
              // bottomNavigationBar: BottomNavigationSend(),
            ),
    );
  }
}
