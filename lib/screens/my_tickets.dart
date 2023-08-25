import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../Provider/Scrap Provider.dart';
import '../Provider/User Provider.dart';
import '../constants.dart';
import '../model/Scrap_model.dart';
import 'chat.dart';
import 'edit_ticket.dart';
import 'ticket_detail.dart';


class MyTickets extends StatefulWidget {
  final String jwdToken;
  final String number;

  const MyTickets({Key? key, required this.jwdToken, required this.number})
      : super(key: key);

  @override
State<MyTickets>   createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  List<ScrapModel> scrap = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
      Stream<int>.periodic(const Duration(seconds: 3), (x) => refreshNum);

  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  Future<void> _handleRefresh() async {
    final Completer<void> completer = Completer<void>();
    await Provider.of<ScrapProvider>(context, listen: false)
        .FetchScrap(widget.number, widget.jwdToken);
    // setState(() {
    //   Ctg_loading = false;
    // });
    completer.complete();
    // Timer(const Duration(seconds: 3), () {
    //
    // });
    setState(() {
      refreshNum = Random().nextInt(20);
    });
    // return completer.future.then<void>((_) {
    //   ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
    //     SnackBar(
    //       content: const Text('Refresh complete'),
    //       action: SnackBarAction(
    //         label: 'RETRY',
    //         onPressed: () {
    //           _refreshIndicatorKey.currentState!.show();
    //         },
    //       ),
    //     ),
    //   );
    // });
  }

  void didChangeDependencies() {
    scrap = Provider.of<ScrapProvider>(context, listen: false).un_sold();
    // final user = await Provider.of<UserProvider>(context, listen: false).items;
    // number = await user[0].user_number.toString();
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void deal_verification(String scrap_id) {
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
                        const Padding(
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
                        const SizedBox(
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 14),
                                child: Text(
                                  'No'.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // accept_scrap(scrap_id)
                                await Provider.of<ScrapProvider>(context)
                                    .accept_scrap(scrap_id, widget.jwdToken);
                              },
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
                              // _edited_scrap = ScrapModel(
                              //   scrap_id: _edited_scrap.scrap_id,
                              //   scrap_ctg: _edited_scrap.scrap_ctg,
                              //   scrap_sub_ctg: _edited_scrap.scrap_sub_ctg,
                              //   // sub_ctg_icon: _edited_scrap.sub_ctg_icon,
                              //   // scrap_title: _edited_scrap.scrap_title,
                              //   scrap_description: _edited_scrap.scrap_description,
                              //   scrap_weight: _edited_scrap.scrap_weight,
                              //   // scrap_price: _edited_scrap.scrap_price,
                              //   phone_number: _edited_scrap.phone_number,
                              //   scrap_images: _edited_scrap.scrap_images,
                              //   scrap_city: _edited_scrap.scrap_city,
                              //   scrap_address: _edited_scrap.scrap_address,
                              //   is_accepted: true,
                              // );
                              // setState(() {
                              //   cheack = true;
                              // });
                              //   await get_token();
                              //   await Provider.of<ScrapProvider>(context, listen: false)
                              //       .UpdateScrap(widget.scrap_id, _edited_scrap, JWDToken!);
                              //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Chat(scrap_id: widget.scrap_id) ));
                              //   Navigator.pop(context);
                              // },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 14),
                                child: Text(
                                  'Yes'.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
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
    // final scrapData = Provider.of<ScrapProvider>(context);
    // final scrap = scrapData.items;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color(0xFF4271B7),
          title: const Text(
            'My Tickets',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: LiquidPullToRefresh(
          height: 8.h,
          // backgroundColor: Colors.greenAccent,
          color: kPrimaryColor,
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          showChildOpacityTransition: false,
          child: ListView.builder(
              itemCount: scrap.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => Chat(
                                scrap_id: scrap[index].scrap_id,
                                inc: 1,
                              )),
                    );
                  },
                  child: Container(
                    height: 16.h,
                    width: 100.w,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1, color: Colors.grey),
                      // border: Border(
                      //   bottom: BorderSide(width: 1.0, color: Colors.grey.shade400),
                      // ),
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
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              ),
                              child: Image.network(
                                scrap[index].scrap_images![0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.sp),
                            child: Container(
                              width: 48.w,
                              height: 16.h,
                              decoration: const BoxDecoration(
                                  // border: Border(
                                  //   // right: BorderSide(width: 1.0, color: Colors.grey),
                                  // ),
                                  ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    SizedBox(
                                      width: 48.w,
                                      // color: Colors.amber,
                                      child: RichText(
                                        text: TextSpan(
                                          text: scrap[index].scrap_ctg,
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.black,
                                              height: 1),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  " ${scrap[index].scrap_sub_ctg}",
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
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Ticket: ${scrap[index].scrap_id!.substring(0, 8)}",
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.grey[700]),
                                    ),
                                    Text(
                                      scrap[index].status,
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.grey[700]),
                                    ),
                                    Text(
                                      'Price: AED ${scrap[index].scrap_price}',
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: scrap[index].scrap_price > 0
                                              ? Colors.green
                                              : Colors.grey[700]),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Date: ${scrap[index].TimeStamp.substring(0, 10)}",
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.grey[700]),
                                    ),
                                    // SizedBox(height: 2.sp,),
                                    // Text(
                                    //   scrap[index].is_sold.toString(),
                                    //   style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
                                    // ),
                                    // SizedBox(
                                    //   height: 2.sp,
                                    // ),
                                    // if (message.isNotEmpty)
                                    // Consumer<MessageProvider>(
                                    //   builder: (ctx, accepted, child) => Container(
                                    //     width: 48.w,
                                    //     // color: Colors.blue,
                                    //     child: Text(
                                    //       message[message.length-1].message,
                                    //       style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 16.h,
                            width: 18.w,
                            decoration: const BoxDecoration(
                              // color: Colors.redAccent,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              // border: Border(
                              //   left: BorderSide(width: 1.0, color: Colors.grey.shade400),
                              // ),
                            ),
                            // height: 12.h,
                            // color: Colors.amber,
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 3.h,
                                  width: 17.w,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: kPrimaryColor,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (scrap[index].is_accepted == false) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditTicket(
                                                    scrap_id:
                                                        scrap[index].scrap_id,
                                                    JWToken: widget.jwdToken,
                                                    Number: widget.number,
                                                  )),
                                        );
                                      }
                                    },
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
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
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TicketDetail(
                                                  scrap_id:
                                                      scrap[index].scrap_id,
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
                                GestureDetector(
                                  onTap: () async {
                                    if (scrap[index].scrap_price > 0) {
                                      if (Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .items[0]
                                              .verified ==
                                          true) {
                                        if (scrap[index].is_accepted == false) {
                                          deal_verification(scrap[index]
                                              .scrap_id
                                              .toString());
                                        }
                                      } else {
                                        verification_dailogbox();
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 3.h,
                                    width: 17.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: scrap[index].is_accepted
                                          ? Colors.grey
                                          : scrap[index].scrap_price > 0
                                              ? Colors.green
                                              : Colors.grey,
                                      // border: Border(
                                      //   bottom: BorderSide(width: 1.0, color: Colors.grey),
                                      // ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        scrap[index].is_accepted
                                            ? 'Accepted'
                                            : "Accept",
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.white),
                                      ),
                                      // child: Container(
                                      //   decoration: BoxDecoration(
                                      //     // color: scrap[index].is_accepted ? Colors.grey : scrap[index].scrap_price > 0 ? Colors.green : Colors.white,
                                      //     // color: Colors.green,
                                      //     borderRadius: BorderRadius.circular(10.sp),
                                      //   ),
                                      //   child: Padding(
                                      //     padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 3.sp),
                                      //     child: Text(
                                      //       scrap[index].is_accepted ? 'Accepted' : "Accept",
                                      //       style: TextStyle(
                                      //           fontSize: 11.sp, color: Colors.black),
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 3.h,
                                  width: 17.w,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: kPrimaryColor,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Chat(
                                                  scrap_id:
                                                      scrap[index].scrap_id,
                                                  inc: 1,
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
                          // PopupMenuButton(
                          //   padding: EdgeInsets.zero,
                          //     shape:  RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(20)),
                          //     elevation: 5,
                          //     onSelected: (value) {
                          //     if (value == 0) {
                          //       Navigator.push(context, MaterialPageRoute(builder: (context) => EditTicket(scrap_id: scrap[index].scrap_id,
                          //       )),);
                          //       }
                          //       if (value == 1)
                          //       Navigator.push(context, MaterialPageRoute(builder: (context) => TicketDetail(scrap_id: scrap[index].scrap_id,)),);
                          //     },
                          //     icon: Icon(Icons.more_vert_rounded, color: Colors.black, size: 30,),
                          //     itemBuilder: (_)=> [
                          //       if (scrap[index].is_accepted == false)
                          //       PopupMenuItem(
                          //         value: 0,
                          //         // padding: EdgeInsets.zero,
                          //         child: GestureDetector(
                          //         // onTap: (){
                          //         //   Navigator.pop(context);
                          //         //   Navigator.push(context, MaterialPageRoute(builder: (context) => EditTicket(scrap_id: scrap[index].scrap_id,)),);
                          //         // },
                          //         child: Container(
                          //           // height:MediaQuery.of(context).size.height / 10,
                          //           width: MediaQuery.of(context).size.width / 5,
                          //           // color: Colors.red,
                          //           child: Padding(
                          //             padding: EdgeInsets.all(6),
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.center,
                          //               children: [
                          //                 Image.asset(
                          //                   'assets/edit.png',
                          //                   height: 25,
                          //                   width: 25,
                          //                 ),
                          //                 SizedBox(
                          //                   width: 8,
                          //                 ),
                          //                 Text(
                          //                   'Edit',
                          //                   style: TextStyle(
                          //                       fontSize: 16, color: Colors.black),
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //         // value: FilterOptions.Favorites,
                          //       ),
                          //       PopupMenuItem(
                          //         value: 1,
                          //         // padding: EdgeInsets.zero,
                          //         child: GestureDetector(
                          //         // onTap: (){
                          //         //   Navigator.pop(context);
                          //         //   Navigator.push(context, MaterialPageRoute(builder: (context) => TicketDetail(scrap_id: scrap[index].scrap_id,)),);
                          //         // },
                          //         child: Container(
                          //           // height: 60,
                          //           width: MediaQuery.of(context).size.width / 5,
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: [
                          //               Image.asset(
                          //                 'assets/detail_icon.png',fit: BoxFit.cover,
                          //                 height: 30,
                          //                 width: 25,
                          //               ),
                          //               SizedBox(
                          //                 width: 5,
                          //               ),
                          //               Text(
                          //                 'Detail',
                          //                 style: TextStyle(
                          //                     fontSize: 16, color: Colors.black),
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //         //   // value: FilterOptions.All,
                          //       ),
                          //     ]
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
