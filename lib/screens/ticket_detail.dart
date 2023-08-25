// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Provider/Scrap Provider.dart';
import '../constants.dart';
import '../model/Scrap_model.dart';

class TicketDetail extends StatefulWidget {
  final String? scrap_id;

  const TicketDetail({Key? key, required this.scrap_id}) : super(key: key);

  @override
  _TicketDetailState createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
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
      scrap_address: "");

  void didChangeDependencies() {
    final scrap_id = widget.scrap_id;
    if (scrap_id != null) {
      _edited_scrap =
          Provider.of<ScrapProvider>(context, listen: false).findById(scrap_id);
    }
  }

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
          title: Text(
            'Ticket Detail',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   child: Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 5.sp),
                //       child: Text("Title", style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),)),
                // ),
                // Container(
                //   height: MediaQuery.of(context).size.height*0.07,
                //   width: MediaQuery.of(context).size.width*0.91,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15),
                //     color: Colors.grey[300],
                //     border: Border.all(width: 1, color: Colors.grey),
                //   ),
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                //     child: Text(
                //       _edited_scrap.scrap_title,
                //       style: TextStyle(
                //         fontSize: 20,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 25,
                // ),
                Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.sp),
                      child: Text(
                        "Number",
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                      )),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.91,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[300],
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      child: Text(
                        _edited_scrap.phone_number.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                // Container(
                //   child: Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 5.sp),
                //       child: Text("Price", style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),)),
                // ),
                // Container(
                //   height: MediaQuery.of(context).size.height*0.07,
                //   width: MediaQuery.of(context).size.width*0.91,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15),
                //     color: Colors.grey[300],
                //     border: Border.all(width: 1, color: Colors.grey),
                //   ),
                //   child: Row(
                //     children: [
                //       Icon(Icons.arrow_drop_down_sharp),
                //       Text(
                //         'LS',
                //         style: TextStyle(fontSize: 14),
                //       ),
                //       SizedBox(
                //         width: 15,
                //       ),
                //       Container(
                //         height: 40,
                //         decoration: BoxDecoration(
                //             border: Border(
                //                 right: BorderSide(
                //                   width: 1,
                //                   color: Colors.grey,
                //                 ))),
                //       ),
                //       Padding(
                //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                //           child: Text(_edited_scrap.scrap_price.toString(), style: TextStyle(color: Colors.black, fontSize: 18,),)),
                //       Spacer(),
                //       Text("AED", style:  TextStyle(
                //         fontSize: 18,
                //         color: Colors.orange,
                //       ),),
                //       SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.sp),
                      child: Text(
                        "Description",
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                      )),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  width: MediaQuery.of(context).size.width * 0.91,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[300],
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        _edited_scrap.scrap_description.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.sp),
                      child: Text(
                        "Weight",
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                      )),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.91,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[300],
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: Text(
                            int.parse(_edited_scrap.scrap_weight) == 0
                                ? ""
                                : _edited_scrap.scrap_weight.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          )),
                      Spacer(),
                      Text(
                        int.parse(_edited_scrap.scrap_weight) == 0
                            ? "Don't Know"
                            : "Per Ton",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue[700],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.sp),
                      child: Text(
                        "City",
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                      )),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.91,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[300],
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: Text(
                            _edited_scrap.scrap_city.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          )),
                      Spacer(),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 28,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.sp),
                      child: Text(
                        "Address",
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                      )),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.91,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[300],
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        _edited_scrap.scrap_address.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      )),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.sp),
                      child: Text(
                        "Pictures",
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                      )),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1.5, color: Colors.black87),
                  ),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _edited_scrap.scrap_images!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 10,
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black87),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.5),
                            child: Image.network(
                              _edited_scrap.scrap_images![index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
