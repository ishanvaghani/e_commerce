import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool outlineBtn;
  final bool isLoading;

  CustomButton({
    @required this.text,
    @required this.onPressed,
    @required this.outlineBtn,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    bool _oulinedBtn = outlineBtn ?? false;
    bool _isLoading = isLoading ?? false;

    return _isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : GestureDetector(
            onTap: onPressed,
            child: Container(
              height: 60.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _oulinedBtn ? Colors.transparent : Colors.black,
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                text ?? 'Text',
                style: TextStyle(
                  fontSize: 16.0,
                  color: _oulinedBtn ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
  }
}
