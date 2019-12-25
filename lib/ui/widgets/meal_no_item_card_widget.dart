import 'package:flutter/material.dart';

class MealNoItemCard extends StatelessWidget {
  final String title;
  final Function() onTap;

  MealNoItemCard({Key key, this.title = 'Meal items', this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      borderOnForeground: true,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "OpenSans"),
            ),
          ),
          Divider(),
          ListTile(
            onTap: onTap,
            title: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.add_circle),
                  ),
                  Text(
                    "Add food".toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
