import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import '../PDF/pdfpreview.dart';
import '../Provider/Message Provider.dart';
import '../Provider/Scrap Provider.dart';
import '../Provider/User Provider.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '../constants.dart';
import '../model/Scrap_model.dart';

class SoldChat extends StatefulWidget {
  final String? scrap_id;

  const SoldChat({Key? key, required this.scrap_id}) : super(key: key);

  @override
  _SoldChatState createState() => _SoldChatState();
}

class _SoldChatState extends State<SoldChat> {
  TextEditingController Message = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker imagePicker = ImagePicker();
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

  // Timer.periodic(Duration(seconds: 5), (timer) {
  // print(DateTime.now());
  // });

  void didChangeDependencies() async {
    final scrap_id = widget.scrap_id;
    if (scrap_id != null) {
      chat_loading = true;

      final user =
          await Provider.of<UserProvider>(context, listen: false).items;
      if (user[0].is_registered == true) {
        TradeLicense = user[0].trade_license_number.toString();
        TrnNo = user[0].trn_number.toString();
        number = user[0].user_number;
      }
      await get_token();
      // Timer.periodic(Duration(seconds: 5), (timer) async{
      //   print("Helo i am a timer");
      // });
      Chat_id = await Provider.of<MessageProvider>(context, listen: false)
          .FetchChat(scrap_id, JWDToken!);
      setState(() {
        _edited_scrap = Provider.of<ScrapProvider>(context, listen: false)
            .findById(scrap_id);
      });
      print(Chat_id);
      chat_loading = false;
      // price.text = _edited_scrap.scrap_price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider> (context, listen: false).items;
    // number = user[0].user_number.toString();
    // name = user[0].user_name.toString();
    final messageData = Provider.of<MessageProvider>(context, listen: false);
    final message = messageData.items;
    // final accepted = Provider.of<ScrapModel>(context, listen: false);
    return SafeArea(
      child: Scaffold(
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
                    margin:
                        EdgeInsets.only(top: 5.sp, bottom: 5.sp, right: 5.sp),
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // child: SingleChildScrollView(
          //   scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(
              //   'Buyers has requested to buy\nyour material',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.w600,
              //       color: Colors.black
              //   ),
              // ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Consumer<ScrapProvider>(
                              builder: (ctx, accepted, child) => ElevatedButton(
                                onPressed: () {
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
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      _edited_scrap.scrap_price > 0
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
                                      borderRadius: BorderRadius.circular(25.0),
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
              SizedBox(
                height: 2.sp,
              ),
              Expanded(
                child: Container(
                  // height: _edited_scrap.is_accepted ? 50.h : 56.5.h,
                  width: 100.w,
                  // color: Colors.blue,
                  child: chat_loading
                      ? SpinKitFadingCircle(
                          color: Colors.blue,
                          size: 80,
                        )
                      : Consumer<MessageProvider>(
                          builder: (ctx, accepted, child) => ListView.builder(
                              itemCount: message.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    index == 0
                                        ? DateChip(
                                            date: DateTime.parse(
                                                message[index].TimeStamp),
                                            color: Color(0x558AD3D5),
                                          )
                                        : message[index]
                                                    .TimeStamp
                                                    .substring(0, 10) !=
                                                message[index - 1]
                                                    .TimeStamp
                                                    .substring(0, 10)
                                            ? DateChip(
                                                date: DateTime.parse(
                                                    message[index].TimeStamp),
                                                color: Color(0x558AD3D5),
                                              )
                                            : Container(),
                                    BubbleSpecialThree(
                                      text: message[index].message,
                                      color:
                                          message[index].senderType == "admin"
                                              ? Color(0xFFE8E8EE)
                                              : Color(0xFF1B97F3),
                                      tail: true,
                                      isSender:
                                          message[index].senderType == "admin"
                                              ? false
                                              : true,
                                      textStyle: TextStyle(
                                          color: message[index].senderType ==
                                                  "admin"
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 14.sp),
                                    ),
                                  ],
                                );
                              }),
                        ),
                ),
              ),
              SizedBox(
                height: 0.6.h,
              ),

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
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.15,
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
            ],
          ),
        ),
      ),
    );
  }
}
