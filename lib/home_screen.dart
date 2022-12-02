import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoapp/screens/camera_screen.dart';
import 'package:geoapp/screens/map_screen.dart';
import 'package:geoapp/screens/signin_screen.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:geoapp/screens/hom_screen.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
final List<Widget> _pages = [
  HomScreen(),
  MapScreen(),
  CameraScreen(),

];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: _pages[_selectedIndex],

 //       currentIndex: _selectedIndex,
 //       onTap: _navigateBottomBar,
 //      type: BottomNavigationBarType.fixed,

      bottomNavigationBar: Container(


        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    child: GNav(
        gap: 8, // the tab button gap between icon and text
        color: Colors.white, // unselected icon color
        activeColor: Colors.white, // selected icon and text color
        tabBackgroundColor: Colors.grey.shade800, // selected tab background color
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        padding: EdgeInsets.all(16),
        tabs: const [
        GButton(icon: Icons.home,
                text: "Domů"),
        GButton(icon: Icons.map_outlined,
                text: "Mapa"),
        GButton(icon: Icons.camera,
                text: "Kamera"),
    ],),
    ),
      ));
  }
}