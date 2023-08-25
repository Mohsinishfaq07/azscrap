// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
//
// import 'package:flutter/material.dart';
//
// class DeleteAlertDialog extends StatelessWidget {
//   const DeleteAlertDialog({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey,
//         body: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Container(
//             height: 150,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15), color: Colors.white),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Are you sure you want to delete the ticket',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 19,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {},
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 23),
//                           child: Text(
//                             'Cancel'.toUpperCase(),
//                             style: TextStyle(fontSize: 20, color: Colors.white),
//                           ),
//                         ),
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(Colors.blue[800]),
//                           foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(25.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {},
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 23),
//                           child: Text(
//                             'Delete'.toUpperCase(),
//                             style: TextStyle(fontSize: 20, color: Colors.white),
//                           ),
//                         ),
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(Colors.red[800]),
//                           foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(25.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
