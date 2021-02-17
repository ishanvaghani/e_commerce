import 'package:e_commerce/screens/home_page.dart';
import 'package:e_commerce/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode _passwordFocusNode;
  String _email = "";
  String _password = "";
  bool _isAuthenticating = false;
  bool _isSignIn = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> _signInUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    setState(() {
      _isAuthenticating = true;
    });

    if (_email.isEmpty) {
      SnackBar snackBar = SnackBar(content: Text('Email can not empty'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else if (_password.isEmpty) {
      SnackBar snackBar = SnackBar(content: Text('Password can not empty'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else {
      if (_isSignIn) {
        String _signInUserFeedback = await _signInUser();
        if (_signInUserFeedback != null) {
          SnackBar snackBar = SnackBar(content: Text(_signInUserFeedback));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contex) => HomePage(),
            ),
          );
        }
      } else {
        String _createAccountFeedback = await _createAccount();
        if (_createAccountFeedback != null) {
          SnackBar snackBar = SnackBar(content: Text(_createAccountFeedback));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contex) => HomePage(),
            ),
          );
        }
      }
    }

    setState(() {
      _isAuthenticating = false;
    });
  }

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isSignIn
                        ? 'Welcome User,\nLogin to your account'
                        : 'Create a New Account',
                    textAlign: TextAlign.center,
                    style: Constants.boldHeading,
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            _email = value;
                          },
                          onSubmitted: (_) {
                            _passwordFocusNode.requestFocus();
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email...",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 18.0),
                          ),
                          style: Constants.regularDarkText,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: TextField(
                          obscureText: true,
                          focusNode: _passwordFocusNode,
                          onChanged: (value) {
                            _password = value;
                          },
                          onSubmitted: (_) {
                            _submitForm();
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password...",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 18.0),
                          ),
                          style: Constants.regularDarkText,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      CustomButton(
                        text: _isSignIn ? 'Login' : 'Create New Account',
                        onPressed: () {
                          _submitForm();
                        },
                        outlineBtn: false,
                        isLoading: _isAuthenticating,
                      ),
                    ],
                  ),
                  CustomButton(
                    text: _isSignIn ? 'Create New Account' : 'Back to Login',
                    onPressed: () {
                      if (_isSignIn) {
                        setState(() {
                          _isSignIn = false;
                        });
                      } else {
                        setState(() {
                          _isSignIn = true;
                        });
                      }
                    },
                    outlineBtn: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
