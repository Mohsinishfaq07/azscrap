// // ignore_for_file: prefer_const_constructors
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zuhour_scrap/model/messageModel.dart';
//
// import '../Provider/Message Provider.dart';
//
// class BottomNavigationSend extends StatefulWidget {
//   const BottomNavigationSend({Key? key}) : super(key: key);
//
//   @override
//   _BottomNavigationSendState createState() => _BottomNavigationSendState();
// }
//
// class _BottomNavigationSendState extends State<BottomNavigationSend> {
//   TextEditingController message = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 70,
//       width: double.infinity,
//       color: Colors.grey[200],
//       child: Padding(
//         padding: const EdgeInsets.only(left: 20, right: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               child: Row(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width / 1.3,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(20))
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10.0),
//                       child: TextField(
//                         cursorColor: Colors.blue,
//                         controller: message,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: ' Type Here',
//                           // icon: Image.asset('assets/emoji.png', height: 25, width: 25,),
//                           suffixIcon: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(Icons.attach_file_rounded, color: Colors.blue, size: 26,),
//                             // child: Image.asset('assets/file.png', height: 15, width: 15,),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 0),
//                     child: IconButton(
//                       onPressed: (){
//                         Provider.of<MessageProvider> (context, listen: false).AddMessage(
//                           MessageModel(
//                             senderType: "User",
//                               message: message.text,
//                               senderName: "Ali",
//                               senderNumber: "+923056381977",
//                           ),
//                         );
//                         message.clear();
//                       },
//                       icon: Icon(
//                         Icons.send,
//                         color: Colors.blue,
//                         size: 30,
//                       ),
//                     )
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
