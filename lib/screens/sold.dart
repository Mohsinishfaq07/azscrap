import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../Provider/Message Provider.dart';
import '../Provider/Scrap Provider.dart';
import '../constants.dart';
import '../model/Scrap_model.dart';
import 'chat.dart';
import 'edit_ticket.dart';
import 'sold_chat.dart';
import 'ticket_detail.dart';

class Sold extends StatefulWidget {
  const Sold({Key? key}) : super(key: key);

  @override
  _SoldState createState() => _SoldState();
}

class _SoldState extends State<Sold> {
  List<ScrapModel> sold_scrap = [];

  @override
  void didChangeDependencies() {
    sold_scrap =
        Provider.of<ScrapProvider>(context, listen: false).sold_ticket();
  }

  @override
  Widget build(BuildContext context) {
    // final scrapData = Provider.of<ScrapProvider>(context);
    // final scrap = scrapData.items;
    final messageData = Provider.of<MessageProvider>(context, listen: false);
    final message = messageData.items;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF4271B7),
          title: Text(
            'Sold Tickets',
            style: TextStyle(color: Colors.white),
          ),
          leading: Text(''),
        ),
        body: ListView.builder(
            itemCount: sold_scrap.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                // onTap: () {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => Chat(scrap_id: scrap[index].scrap_id,)),
                //   );
                // },
                child: Container(
                  height: 16.h,
                  width: 100.w,
                  margin: EdgeInsets.symmetric(
                    horizontal: 6.sp,
                    vertical: 4.sp,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    //     border: Border(
                    //       top: BorderSide(width: 1.sp, color: Colors.grey),
                    //   bottom: BorderSide(width: 1.sp, color: Colors.grey),
                    //   left: BorderSide(width: 1.sp, color: Colors.grey),
                    //   right: BorderSide(width: 1.sp, color: Colors.grey),
                    // ),
                    border: Border.all(width: 1.sp, color: Colors.grey),
                    color: Colors.white,
                    // color: Color(0xFFD1D3D4),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 16.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            // color: Colors.blueAccent[100]),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7),
                              topLeft: Radius.circular(7),
                            ),
                            child: Image.network(
                              sold_scrap[index].scrap_images![0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.sp),
                          child: Container(
                            width: 48.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              border: Border(
                                  // right: BorderSide(width: 1.0, color: Colors.grey),
                                  ),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Container(
                                    width: 48.w,
                                    // color: Colors.amber,
                                    child: RichText(
                                      text: TextSpan(
                                        text: sold_scrap[index].scrap_ctg,
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            height: 1),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                " ${sold_scrap[index].scrap_sub_ctg}",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // child: Text(
                                    //   "${scrap[index].scrap_ctg}" + "${scrap[index].scrap_sub_ctg}",
                                    //   textAlign: TextAlign.start,
                                    //   style: TextStyle(fontSize: 20, color: Colors.black, height: 1),
                                    // ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Ticket: ${sold_scrap[index].scrap_id!.substring(0, 8)}",
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.grey[700]),
                                  ),
                                  Text(
                                    sold_scrap[index].status,
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.grey[700]),
                                  ),
                                  Text(
                                    'Price: AED ${sold_scrap[index].scrap_price}',
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.grey[700]),
                                  ),
                                  Text(
                                    'Date: ${sold_scrap[index].TimeStamp.substring(0, 10)}',
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 16.h,
                          width: 18.w,
                          // decoration: BoxDecoration(
                          //   // color: Colors.redAccent,
                          //   // borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),topRight:Radius.circular(15), ),
                          //   // border: Border(
                          //   //   right: BorderSide(width: 1.0, color: Colors.grey),
                          //   // ),
                          // ),
                          // height: 12.h,
                          // color: Colors.amber,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 1.h,
                              ),
                              Container(
                                height: 3.h,
                                width: 17.w,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    primary: kPrimaryColor,
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TicketDetail(
                                                scrap_id:
                                                    sold_scrap[index].scrap_id,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    'Detail',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Container(
                                height: 3.h,
                                width: 17.w,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => SoldChat(
                                                scrap_id:
                                                    sold_scrap[index].scrap_id,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    'Chat',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
