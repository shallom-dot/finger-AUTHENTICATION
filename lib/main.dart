import 'dart:ffi';

import 'package:finger_authentication/secondpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FingerprintApp(),
    ));

class FingerprintApp extends StatefulWidget {
  @override
  _FingerprintAppState createState() => _FingerprintAppState();
}

class _FingerprintAppState extends State<FingerprintApp> {
  //creating the main function that will allow me use
  //the fingerprint sensor and authenticate
  //but first ill add a local_auth dependency and use fingerprint permission
  //start by creating some variables
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric;
  List<BiometricType>
      _availableBiometrics; //this list will store all types of biometric sensor like fingerprint.
  String autherized = "Not autherized";
  //this string will allow me check if i can access our app or not
  //this function will allow me to check my biometric sensor
  Future<void> _checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

//now ive checked if im allowed to check my biometric lets get
//available biometric sensor on my device
  Future<Void> _getAvailableBiometric() async {
    List<BiometricType> availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometrics = availableBiometric;
    });
  }

  //now the main function which will allow me authenticate
  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: "Scan your finger to authenticate",
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      //here ill write what our app will do if the user authenticated
      autherized =
          authenticated ? "Authorized success" : "Failed to authenticate";
      if (authenticated) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SecondPage()));
      }
      print(autherized);
    });
  }

  @override
  Void initState() {
    _checkBiometric();
    _getAvailableBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xFF3C3E52),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                "Login",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                children: <Widget>[
                  Image.network(
                    "https://media.kasperskydaily.com/wp-content/uploads/sites/92/2015/12/06023350/fingerprints-FB-1.jpg",
                    width: 120.0,
                  ),
                  Text(
                    "Fingerprint Auth",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    width: 150.0,
                    child: Text(
                      "Authentication using your fingerprint instead of your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: _authenticate,
                      elevation: 0.0,
                      color: Color(0xFF04A5ED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 24.0),
                        child: Text(
                          "Authentication",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
