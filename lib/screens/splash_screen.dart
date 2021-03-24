import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final String error;
  SplashScreen(this.error);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error != null ? error : 'Loading...'),
      ),
    );
  }
}
