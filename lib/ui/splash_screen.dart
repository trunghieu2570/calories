import 'package:calories/blocs/auth/bloc.dart';
import 'package:calories/blocs/favorite_foods/bloc.dart';
import 'package:calories/blocs/login/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loginBloc.add(LoginWithGooglePressed());
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSuccess){
          BlocProvider.of<AuthBloc>(context).add(AppLoggedIn());

        }
        return Scaffold(
          body: Center(child: Text('Splash Screen')),
        );
      }
    );
  }
}
