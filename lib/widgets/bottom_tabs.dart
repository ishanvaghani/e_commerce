import 'package:e_commerce/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  BottomTabs({this.selectedTab, this.tabPressed});

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1.0,
            blurRadius: 30.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabButton(
            imagePath: 'assets/images/tab_home.png',
            onPressed: () {
              widget.tabPressed(0);
            },
            selected: widget.selectedTab == 0 ? true : false,
          ),
          BottomTabButton(
            imagePath: 'assets/images/tab_search.png',
            onPressed: () {
              widget.tabPressed(1);
            },
            selected: widget.selectedTab == 1 ? true : false,
          ),
          BottomTabButton(
            imagePath: 'assets/images/tab_saved.png',
            onPressed: () {
              widget.tabPressed(2);
            },
            selected: widget.selectedTab == 2 ? true : false,
          ),
          BottomTabButton(
            imagePath: 'assets/images/tab_logout.png',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            selected: widget.selectedTab == 3 ? true : false,
          ),
        ],
      ),
    );
  }
}

class BottomTabButton extends StatelessWidget {
  final String imagePath;
  final bool selected;
  final Function onPressed;
  BottomTabButton({@required this.imagePath, this.selected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _selected
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 28.0, horizontal: 24.0),
        child: Image.asset(
          imagePath,
          width: 22.0,
          height: 22.0,
          color: _selected ? Theme.of(context).accentColor : Colors.black,
        ),
      ),
    );
  }
}
