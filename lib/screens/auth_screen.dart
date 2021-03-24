import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../models/http_exceptions.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const url = "/auth-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                  colors: [
                    Colors.grey,
                    Colors.blueGrey,
                    // Colors.pink,
                    // Colors.yellow,
                    // Colors.green,
                  ],
                  center: Alignment.topLeft,
                  radius: 0.25,
                  focal: Alignment.topLeft,
                  tileMode: TileMode.mirror
                  // begin: Alignment.topLeft,
                  // end: Alignment.bottomRight,
                  ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: AuthCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  var authMode = AuthMode.Login;

  Map<String, String> _authCard = {
    "email": "",
    "password": "",
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("An Error Occured"),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Okay"),
          )
        ],
      ),
    );
  }

  void submit() async {
    final isValid = _formKey.currentState.validate();

    if (!isValid) return;

    _formKey.currentState.save();
    var errorMessage;
    final auth = Provider.of<Auth>(context);
    setState(() {
      isLoading = true;
    });
    try {
      if (authMode == AuthMode.Signup) {
        await auth.signUp(
          _authCard["email"],
          _authCard["password"],
        );
      } else {
        await auth.signIn(
          _authCard["email"],
          _authCard["password"],
        );
      }
    } on HttpException catch (error) {
      errorMessage = "Authentication failed.";
      print("${error.toString()} 12");
      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "This email address is already in use.";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "This is email address is not valid.";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "This password is too weak.";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Could not found user with that email.";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid Password";
      }
      _showErrorDialog(errorMessage);
      // _showErrorDialog(errorMessage);
    } catch (err) {
      errorMessage = "Couldnt authenticate";
      _showErrorDialog(errorMessage);
    }
    setState(() {
      isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (authMode == AuthMode.Login) {
      setState(() {
        authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              "Sign In",
              style: TextStyle(
                fontSize: 30,
                // backgroundColor: Colors.black54,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value.isEmpty || !value.contains('@')) {
                  return 'Invalid email!';
                }
                return null;
              },
              onSaved: (value) {
                _authCard["email"] = value;
              },
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white54),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: "email",
                filled: true,
                fillColor: Colors.black26,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value.isEmpty || value.length < 5) {
                  return "Please enter a valid password";
                }
                return null;
              },
              // TODO : password controller'a bak
              controller: _passwordController,
              obscureText: true,
              onSaved: (value) {
                _authCard["password"] = value;
              },

              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white54),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: "password",
                filled: true,
                fillColor: Colors.black26,
              ),
            ),
            SizedBox(height: 10),
            // if (authMode == AuthMode.Signup)
            AnimatedContainer(
              constraints: BoxConstraints(
                minHeight: authMode == AuthMode.Signup ? 60 : 0,
                maxHeight: authMode == AuthMode.Signup ? 120 : 0,
              ),
              duration: Duration(milliseconds: 300),
              child: TextFormField(
                validator: authMode == AuthMode.Signup
                    ? (value) {
                        if (value.isEmpty || value.length < 5) {
                          print(12);
                          return "Please enter a valid password";
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match!';
                        }
                        return null;
                      }
                    : null,
                enabled: authMode == AuthMode.Signup,
                obscureText: true,
                controller: _confirmController,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelStyle: TextStyle(color: Colors.white54),
                  labelText: "confirm password",
                  filled: true,
                  fillColor: Colors.black26,
                ),
              ),
            ),
            SizedBox(height: 10),
            isLoading
                ? Padding(
                    padding: EdgeInsets.all(5),
                    child: CircularProgressIndicator(),
                  )
                : RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    color: Colors.green,
                    onPressed: () {
                      submit();
                    },
                    child: Text(
                      "${authMode == AuthMode.Signup ? "sign up" : "sign in"}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
            FlatButton(
              // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                // TODO : Metinlerin niye üst üste bindiğine bak
                _confirmController.text = "";
                _switchAuthMode();
              },
              child: Text(
                "${authMode == AuthMode.Signup ? "sign in" : "sign up"} instead",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
