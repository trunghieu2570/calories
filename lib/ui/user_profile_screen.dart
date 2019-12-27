import 'package:cached_network_image/cached_network_image.dart';
import 'package:calories/blocs/auth/bloc.dart';
import 'package:calories/ui/edit_profile_screen.dart';
import 'package:calories/ui/screens/goal/edit_goal_screen.dart';
import 'package:calories/ui/screens/reminder/setup_reminders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is Authenticated) {
        var user = state.user;
        return Container(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: Scaffold(
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    elevation: 0,
                    iconTheme: IconThemeData(color: Colors.grey[800]),
                    backgroundColor: Colors.white24,
                    pinned: true,
                    floating: true,
                    snap: false,
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.only(left: 15, bottom: 15),
                      title: Text(
                        "Profile",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 20,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditProfileScreen()))),
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () => {},
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 30, bottom: 15),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(user.photoUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(80.0)),
                          border: new Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                        /* child: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(user.photoUrl),
                        ), */
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        user.fullName,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'OpenSans',
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Divider(
                      indent: 50,
                      endIndent: 50,
                      height: 20,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "HEIGHT",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  user.height != null
                                      ? user.height?.toString()
                                      : '0',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "centimeters",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () => {},
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "WEIGHT",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  user.weight != null
                                      ? user.weight.toString()
                                      : '0',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "kilograms",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () => {},
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "AGE",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  user.birthday != null
                                      ? _calculateAge(user.birthday).toString()
                                      : '0',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "years",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () => {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Divider(
                      height: 30,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: Text(
                          "Customize",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        borderOnForeground: true,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditGoalScreen())),
                          contentPadding: EdgeInsets.symmetric(horizontal: 25),
                          leading: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 18,
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            "Setup Goals",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        borderOnForeground: true,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SetRemindersScreen())),
                          contentPadding: EdgeInsets.symmetric(horizontal: 25),
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            "Reminders",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      /*Card(
                        elevation: 0,
                        borderOnForeground: true,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          onTap: () => {},
                          contentPadding: EdgeInsets.symmetric(horizontal: 25),
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            "Favorite Foods",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),*/
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: Text(
                          "Application",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        borderOnForeground: true,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          onTap: () async {
                            const url = 'https://github.com/trunghieu2570/calories/issues/new';
                            if (await canLaunch(url)) {
                              await launch(url);
                            }
                          },
                          contentPadding: EdgeInsets.symmetric(horizontal: 25),
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.purple,
                            child: Icon(
                              Icons.bug_report,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            "Bug Report",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        borderOnForeground: true,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          onTap: () => _showInfoDialog(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 25),
                          leading: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.error,
                                color: Colors.white,
                              )),
                          title: Text(
                            "About This App",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        borderOnForeground: true,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          onTap: () => _authBloc.add(AppLoggedOut()),
                          contentPadding: EdgeInsets.symmetric(horizontal: 25),
                          leading: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.amber,
                              child: Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              )),
                          title: Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 80,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      return Text("No user information");
    });
  }

  int _calculateAge(DateTime birthday) {
    final now = DateTime.now();
    return now.year - birthday.year;
  }

  Future<bool> _showInfoDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dContext) {
        return AlertDialog(
          title: Text('About this app'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Version: 1.0.0'),
              Text('Developer: Tran Trung Hieu'),
              Text('Email: trunghieu2570@gmail.com'),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'.toUpperCase()),
              onPressed: () {
                Navigator.pop(dContext, true);
              },
            )
          ],
        );
      },
    );
  }
}
