import 'package:flutter/material.dart';

class DirectionsCard extends StatelessWidget {
  final List<String> directions;

  DirectionsCard({Key key, @required this.directions})
      : assert(directions != null),
        super(key: key);

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
              'Directions',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "OpenSans"),
            ),
          ),
          Divider(),
          ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, int index) {
              final direction = directions[index];
              return ListTile(
                leading: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircleAvatar(
                    child: Text(
                      index.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  direction,
                ),
              );
            },
            itemCount: directions.length,
          )
        ],
      ),
    );
  }
}
