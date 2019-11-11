import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Foods extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FoodsState();
}

class FoodsState extends State<Foods> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool headerSliverBuilder) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: true,
              forceElevated: true,
              title: Text(
                "Đồ ăn thức uống",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  tooltip: "Tìm kiếm",
                  onPressed: () => {},
                ),
                IconButton(
                  icon: Icon(Icons.mic_none),
                  tooltip: "Tìm kiếm bằng giọng nói",
                  onPressed: () => {},
                )
              ],
              bottom: TabBar(
                labelColor: Colors.black,
                tabs: <Widget>[
                  Tab(text: "Dành cho bạn"),
                  Tab(text: "Nổi bật"),
                  Tab(text: "Danh mục"),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            CustomScrollView(
              //physics: NeverScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return DecoratedBox(
                        child: ListTile(
                          title: Text("HelloWorld $index"),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
