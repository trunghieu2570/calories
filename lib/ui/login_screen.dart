import 'package:calories/blocs/auth/bloc.dart';
import 'package:calories/blocs/login/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;
  AuthBloc _authBloc;
  bool _showIndicator = false;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state.isSuccess) {
        _authBloc.add(AppLoggedIn());
      }
      return Scaffold(
        backgroundColor: Colors.green[300],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "calories",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w600,
                ),
              ),
              OutlineButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: Colors.white,
                  borderSide: BorderSide(color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _showIndicator = true;
                    });
                    _loginBloc.add(LoginWithGooglePressed());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Visibility(
                        visible: _showIndicator,
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)),
                      ),
                      Container(
                        child: Text(
                          "Login with Google",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      );
    });
  }
}
