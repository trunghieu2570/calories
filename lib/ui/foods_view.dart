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
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () => {},
                    title: Text(
                      'Có thể bạn sẽ thích',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: 'OpenSans'),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 15,
                      itemBuilder: (BuildContext context, int index) =>
                          new Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://placeimg.com/640/480/any'),
                                    fit: BoxFit.fill)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  child: ListTile(
                                    title: Text(
                                      'Title',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      'Subtitle',
                                      style: TextStyle(color: Colors.white38),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(100),
                                  ),
                                )
                              ],
                            )),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Được bạn dùng thường xuyên',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: 'OpenSans'),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 15,
                      itemBuilder: (BuildContext context, int index) => Card(
                        child:
                            Center(child: Text('Dummy Card Texthhhhhhhhhhhh')),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Món ăn bạn nên thử hôm nay',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: 'OpenSans'),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 15,
                      itemBuilder: (BuildContext context, int index) => Card(
                        child:
                            Center(child: Text('Dummy Card Texthhhhhhhhhhhh')),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Món ăn yêu thích',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: 'OpenSans'),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 15,
                      itemBuilder: (BuildContext context, int index) => Card(
                        child:
                            Center(child: Text('Dummy Card Texthhhhhhhhhhhh')),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Đồ uống yêu thích',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: 'OpenSans'),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 15,
                      itemBuilder: (BuildContext context, int index) => Card(
                        child:
                            Center(child: Text('Dummy Card Texthhhhhhhhhhhh')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
