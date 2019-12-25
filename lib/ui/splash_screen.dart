import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //_loginBloc = BlocProvider.of<LoginBloc>(context);
    //_loginBloc.add(LoginWithGooglePressed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: Center(
          child: Text(
        "calories",
        style: TextStyle(
          fontSize: 50,
          color: Colors.white,
          fontFamily: "OpenSans",
          fontWeight: FontWeight.w600,
        ),
      )),
    );
  }
}
