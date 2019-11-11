import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
              icon: Icon(Icons.settings),
              onPressed: () => {},
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 30, bottom: 15),
            width: 150,
            height: 150,
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 2.5,
                offset: Offset(1.5, 1.5),
                color: Colors.indigo.withAlpha(70),
              ),
            ]),
            child: CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Text(
                'T',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: Text(
              "Tran Trung Hieu",
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
              "trunghieu@gmail.com",
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
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
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
                  backgroundColor: Colors.green,
                  radius: 18,
                  child: Icon(
                    Icons.offline_pin,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  "Thiết lập mục tiêu",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
                "Ứng dụng",
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
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
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
    );
  }
}
