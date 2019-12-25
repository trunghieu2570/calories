import 'package:calories/blocs/auth/bloc.dart';
import 'package:calories/ui/screens/goal/edit_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        final user = state.user;
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: false,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 15, bottom: 15),
                  title: Text(
                    "Hồ sơ",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.bold),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => {},
                  ),
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
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
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
                              "CHIỀU CAO",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "180",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "xentimét",
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
                              "CÂN NẶNG",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "100",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "kilôgam",
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
                              "ĐỘ TUỔI",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "30",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "tuổi",
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
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Text(
                      "Cá nhân hóa",
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    borderOnForeground: true,
                    margin: EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => EditGoalScreen())),
                      contentPadding: EdgeInsets.symmetric(horizontal: 25),
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 18,
                        child: Icon(
                          Icons.offline_pin,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "Thiết lập mục tiêu",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    borderOnForeground: true,
                    margin: EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(
                      onTap: () => {},
                      contentPadding: EdgeInsets.symmetric(horizontal: 25),
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.notifications_active,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "Nhắc nhở",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Card(
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
                        "Món ăn yêu thích",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Text(
                      "Ứng dụng",
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    borderOnForeground: true,
                    margin: EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(
                      onTap: () => {},
                      contentPadding: EdgeInsets.symmetric(horizontal: 25),
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.purple,
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "Cài đặt",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    borderOnForeground: true,
                    margin: EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(
                      onTap: () => {},
                      contentPadding: EdgeInsets.symmetric(horizontal: 25),
                      leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.error,
                            color: Colors.white,
                          )),
                      title: Text(
                        "Thông tin ứng dụng",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
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
                        "Đăng xuất",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
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
        );
      }
      return Text("No user information");
    });
  }
}
