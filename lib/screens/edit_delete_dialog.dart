// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class EditDeleteDialog extends StatelessWidget {
  const EditDeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 110,
            width: MediaQuery.of(context).size.width / 2.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/edit.png', height: 30, width: 30,),
                      SizedBox(width: 15,),
                      Text('Edit', style: TextStyle(fontSize: 16, color: Colors.black),)
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: 90,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1, color: Colors.grey,)
                      )
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/delete.png', height: 30, width: 30,),
                      SizedBox(width: 15,),
                      Text('Delete', style: TextStyle(fontSize: 16, color: Colors.black),)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
