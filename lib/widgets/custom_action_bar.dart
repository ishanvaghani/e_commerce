import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/cart_page.dart';
import 'package:e_commerce/services/firebase_services.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitle;
  final bool hasBackground;
  final bool hasCart;

  CustomActionBar({
    this.title,
    this.hasBackArrow,
    this.hasTitle,
    this.hasBackground,
    this.hasCart,
  });

  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: hasBackground
            ? LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0)],
                begin: Alignment(0, 0),
                end: Alignment(0, 1),
              )
            : null,
      ),
      padding: EdgeInsets.only(
        top: 56.0,
        left: 24.0,
        right: 24.0,
        bottom: 42.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (hasBackArrow)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42.0,
                    height: 42.0,
                    margin: EdgeInsets.only(
                      right: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/back_arrow.png',
                      color: Colors.white,
                      width: 16.0,
                      height: 16.0,
                    ),
                  ),
                ),
              if (hasTitle)
                Text(
                  title,
                  style: Constants.boldHeading,
                ),
            ],
          ),
          if (hasCart)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
              },
              child: StreamBuilder(
                stream: _firebaseServices.userRef
                    .doc(_firebaseServices.getUserId())
                    .collection('Cart')
                    .snapshots(),
                builder: (context, snapshot) {
                  int _totalItems = 0;

                  if (snapshot.connectionState == ConnectionState.active) {
                    List _documents = snapshot.data.docs;
                    _totalItems = _documents.length;
                  }

                  return Container(
                    width: 42.0,
                    height: 42.0,
                    decoration: BoxDecoration(
                      color: _totalItems > 0
                          ? Theme.of(context).accentColor
                          : Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$_totalItems" ?? '0',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
