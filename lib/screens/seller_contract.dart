// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class SellerContract extends StatefulWidget {

  @override
  State<SellerContract> createState() => _SellerContractState();
}

class _SellerContractState extends State<SellerContract> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Seller Contract',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "I agree to sell my material for",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  children: [
                    TextSpan(text: " 50,000 DHS ", style: TextStyle(fontSize: 18, color: Colors.red[600])),
                    TextSpan(text: "to the buyer. ", style: TextStyle(fontSize: 18, color: Colors.black)),
                    TextSpan(text: "13 ton copper ".toUpperCase(), style: TextStyle(fontSize: 18, color: Colors.orange[300])),
                    TextSpan(text: "(If the seller provided excel sheet then show excel sheet)", style: TextStyle(fontSize: 18, color: Colors.black)),
                  ]
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width/2.2,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width/2.2,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width/2.2,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width/2.2,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20,),
              Icon(Icons.qr_code_2, size: 150,)
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 80,
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(width: 1, color: Colors.grey)
              )
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.airplane_ticket),
                  label: 'Ticket'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'User'
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
