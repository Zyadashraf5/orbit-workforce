import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/screens/documentaion/documentaion_screen.dart';
import 'package:orbit_workforce/screens/home_screen/home_screen.dart';
import 'package:orbit_workforce/screens/profile_screen/profile_screen.dart';
import 'package:orbit_workforce/screens/request_screen/request_type_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class AnimatedBarExample extends StatefulWidget {
  const AnimatedBarExample({super.key});

  @override
  State<AnimatedBarExample> createState() => _AnimatedBarExampleState();
}

class _AnimatedBarExampleState extends State<AnimatedBarExample> {
  dynamic selected;
  var heart = false;
  PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBody: true, //to make floating action button notch transparent
        bottomNavigationBar: StylishBottomBar(
          option: AnimatedBarOptions(
            // iconSize: 32,
            barAnimation: BarAnimation.fade,
            iconStyle: IconStyle.Default,
            // opacity: 0.3,
          ),
          items: [
            BottomBarItem(
              icon: Image.asset(
                'assets/images/home.png',
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
              selectedIcon: Image.asset(
                'assets/images/home2.png',
                width: 22,
                height: 22,
                fit: BoxFit.cover,
              ),
              // selectedColor: Colors.teal,
              selectedColor: HexColor('#004ADB'),
              title: Text(
                'home'.tr,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
            ),
            BottomBarItem(
              icon: Image.asset(
                'assets/images/requestes.png',
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
              selectedIcon: Image.asset(
                'assets/images/requestes2.png',
                width: 22,
                height: 22,
                fit: BoxFit.cover,
              ),
              // selectedColor: Colors.teal,
              selectedColor: HexColor('#004ADB'),
              title: Text(
                'requests'.tr,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
            ),
            BottomBarItem(
              icon: Image.asset(
                'assets/images/documents.png',
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
              selectedIcon: Image.asset(
                'assets/images/documents2.png',
                width: 22,
                height: 22,
                fit: BoxFit.cover,
              ),
              // selectedColor: Colors.teal,
              selectedColor: HexColor('#004ADB'),
              title: Text(
                'reports'.tr,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
            ),
            BottomBarItem(
              icon: Image.asset(
                'assets/images/menu.png',
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
              selectedIcon: Image.asset(
                'assets/images/menu2.png',
                width: 22,
                height: 22,
                fit: BoxFit.cover,
              ),
              // selectedColor: Colors.teal,
              selectedColor: HexColor('#004ADB'),
              title: Text(
                'menu'.tr,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
            ),
          ],
          hasNotch: true,
          fabLocation: StylishBarFabLocation.center,
          currentIndex: selected ?? 0,
          onTap: (index) {
            controller.jumpToPage(index);
            setState(() {
              selected = index;
            });
          },
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            gradient: LinearGradient(
              colors: [HexColor('#004ADB'), HexColor('#02A4BF')],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.8, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: FloatingActionButton(
            isExtended: true,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
                topLeft: Radius.circular(100),
              ),
            ),
            onPressed: () {},
            backgroundColor: Colors.transparent,
            child: const Icon(CupertinoIcons.add, color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: PageView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const HomeScreen(),
              const RequestTypeScreen(),
              const DocumentaionScreen(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
