import 'package:flutter/material.dart';
import 'package:flutter_cast_video/flutter_cast_video.dart';
import 'package:snowfall/snowfall.dart';

import '../about.dart';
import '../donate.dart';
import '../landscape_orientation.dart';
import '../msvit.dart';
import '../portrait_orientation.dart';
import '../screen/screenutil.dart';
import '../themes/colors.dart';
import '../token.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  State<SideDrawer> createState() => _SideDrawer();
}

class _SideDrawer extends State<SideDrawer> {
  int _selectedIndex = 0;
  ChromeCastController? _controller;

  void _onItemTapped(int index) {
    setState(() {
      print("Selected index $index");
      _selectedIndex = index;
    });
  }

  Widget getScene() {
    if (_selectedIndex == 0) {
      return getMain();
    } else if (_selectedIndex == 1) {
      return const Msvit();
    } else if (_selectedIndex == 2) {
      return const Token();
    } else if (_selectedIndex == 3) {
      return const Donate();
    } else if (_selectedIndex == 4) {
      return const About();
    } else {
      return getMain();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context: context, width: 375, height: 768);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Радіозорі"),
        actions: [
          ChromeCastButton(
            onButtonCreated: (controller) {
              setState(() => _controller = controller);
              _controller?.addSessionListener();
            },
            onSessionStarted: () {
              print("onSessionStarted");
              _controller?.loadMedia(
                  'https://myradio24.org/35408');
            },
            onPlayerStatusUpdated: (status) {
                print("onPlayerStatusUpdated $status");
            },
            onSessionEnded:() {
              print("onSessionEnded");

            },
            onRequestCompleted: () {
              print("onRequestCompleted");
            },
            onRequestFailed: (info) {
              print("onRequestFailed $info");
            },
          ),
        ],
      ),
      body: Center(child: getScene()),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.radioPurple,
              ),
              child: Text('Радіозорі'),
            ),
            ListTile(
              title: const Text('Музика'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Канал M SVIT'),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Token Rmx'),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Підтримайте нас ♡'),
              selected: _selectedIndex == 3,
              onTap: () {
                // Update the state of the app
                _onItemTapped(3);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('About'),
              selected: _selectedIndex == 4,
              onTap: () {
                // Update the state of the app
                _onItemTapped(4);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getMain() {
    return Container(
      child: SnowfallWidget(
          child: OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return const SafeArea(child: PortraitOrientation());
              } else {
                return const SafeArea(child: LandscapeOrientation());
              }
            },
          ),
          color: Colors.amberAccent,
          numberOfSnowflakes: 50),
      color: Theme.of(context).colorScheme.background,
    );
  }
}
