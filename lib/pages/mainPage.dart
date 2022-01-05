// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maintenance/pages/profile.dart';
import 'package:maintenance/services/auth.dart';
import 'package:maintenance/pages/activity.dart';
import 'package:maintenance/services/database.dart';
import 'package:maintenance/services/location.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _advancedDrawerController = AdvancedDrawerController();
  int currentIndex = 0;
  static final String uid = FirebaseAuth.instance.currentUser!.uid;
  List<Widget> pages = [];

  onTap(selectedPageIndex) {
    setState(() {
      currentIndex = selectedPageIndex;
    });
  }

  GeoPoint? cPosition;
  @override
  void initState() {
    super.initState();
    cPosition=getUserLocation() as GeoPoint;
      pages = [
     const ActivityPage(),
      ProfilePage(
        my: true,
        uid: uid,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.grey[800],
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: true,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
          body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: currentIndex,
              children: pages,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Card(
                margin: const EdgeInsets.all(5),
                elevation: 15,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                  onPressed: _handleMenuButtonPressed,
                  icon: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: _advancedDrawerController,
                    builder: (_, value, __) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          value.visible ? Icons.clear : Icons.menu,
                          size: 30,
                          key: ValueKey<bool>(value.visible),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      )),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/img/tech.png'),
              ),
              ListTile(
                onTap: () {
                  _advancedDrawerController.toggleDrawer();
                  onTap(0);
                },
                leading: const Icon(Icons.home),
                title: const Text('Home'),
              ),
              ListTile(
                onTap: () {
                  _advancedDrawerController.toggleDrawer();
                  onTap(1);
                },
                leading: const Icon(Icons.account_circle_rounded),
                title: const Text('Profile'),
              ),
              ListTile(
                onTap: () {
                  _advancedDrawerController.toggleDrawer();
                  addLocation2(cPosition!);
                },
                leading: const Icon(Icons.location_on_outlined),
                title: const Text('Make visible'),
              ),
              ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const Autenticate()));
                },
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
              ),
              const Spacer(),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: const Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}