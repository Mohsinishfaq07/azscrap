import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/Categories Provider.dart';
import '../Provider/Scrap Provider.dart';
import '../Provider/User Provider.dart';
import 'home_screen.dart';
import 'my_tickets.dart';
import 'profile.dart';

class MyNavigationBar extends StatefulWidget {
  final String jwtToken;
  final String number;
  final int index;

  const MyNavigationBar({Key? key, required this.jwtToken, required this.number, required this.index,}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState(index);
}

class _MyNavigationBarState extends State<MyNavigationBar > {
  List<Widget> _widgetOptions = [];
  final int index;
  final int chak = 1;
  int _selectedIndex = 0;
  void didChangeDependencies () async {
    if (index == 2){
      _selectedIndex = 1;
    }else {
      _selectedIndex = 0;
    }
    _widgetOptions = <Widget>[
      HomeScreen(jwtToken: widget.jwtToken, number: widget.number, check1: 1),
      MyTickets(jwdToken: widget.jwtToken, number: widget.number,),
      Profile(JWToken: widget.jwtToken, Number: widget.number,),
    ];

  }


  _MyNavigationBarState(this.index);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/home.png',
                width: 25,
                height: 25,
              ),
              activeIcon: Image.asset(
                'assets/home_active.png',
                width: 25,
                height: 25,
              ),
              label: 'Sell',
            ),
            BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/ticket_icon.png',
                  width: 25,
                  height: 25,
                ),
                activeIcon: Image.asset(
                  'assets/ticket_active.png',
                  width: 25,
                  height: 25,
                ),
                label: 'Ticket'),
            BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/user_icon.png',
                  width: 25,
                  height: 25,
                ),
                activeIcon: Image.asset(
                  'assets/user_active.png',
                  width: 25,
                  height: 25,
                ),
                label: 'User'),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5
      ),
    );
  }
}