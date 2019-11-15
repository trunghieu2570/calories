import 'package:calories/ui/food_search_page.dart';
import 'package:calories/ui/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Foods extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FoodsState();
}

class FoodsState extends State<Foods> {
  int _selectedTab = 0;

  void onTabBarTapped(int index) {
    return setState(() {
      _selectedTab = index;
    });
  }

  Future onSearchIconPressed(BuildContext context) {
    if (_selectedTab == 2)
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => FoodSearch()));
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => RecipeSearch()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (_, bool) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                forceElevated: true,
                title: Text(
                  "Món ăn yêu thích",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.search),
                      tooltip: "Tìm kiếm",
                      onPressed: () => onSearchIconPressed(context)),
                  IconButton(
                    icon: Icon(Icons.mic_none),
                    tooltip: "Tìm kiếm bằng giọng nói",
                    onPressed: () => {},
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  onTap: (index) => onTabBarTapped(index),
                  labelColor: Colors.grey[800],
                  tabs: <Widget>[
                    Tab(
                      text: 'Bữa ăn',
                    ),
                    Tab(
                      text: 'Công thức nấu ăn',
                    ),
                    Tab(
                      text: 'Thực phẩm',
                    )
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              buildMealsView(),
              buildRecipesView(),
              buildFoodsView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFoodsView() => CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                onTap: () => {},
                title: Text(
                  'Danh mục các loại thực phẩm',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) => new Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://placeimg.com/640/480/any?dummy=$index`'),
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
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(0),
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
                  'Thực phẩm yêu thích của bạn',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'OpenSans'),
                ),
                trailing: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
          SliverList(delegate: SliverChildBuilderDelegate(
            (_, int index) {
              return Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  height: 70,
                  child: ListTile(
                    title: Text('Title'),
                    subtitle: Text('Subtitle'),
                  ),
                ),
              );
            },
          )),
        ],
      );

  Widget buildMealsView() => CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                onTap: () => {},
                title: Text(
                  'Được lựa chọn dành cho bạn',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) => Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      width: 150,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://placeimg.com/640/480/any?dummy=$index'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: ListTile(
                              title: Text('Title'),
                              subtitle: Text('Subtitle'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Bữa ăn yêu thích của bạn',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'OpenSans'),
                ),
                trailing: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
          SliverList(delegate: SliverChildBuilderDelegate(
            (_, int index) {
              return Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  height: 75,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image(
                        image: NetworkImage('https://placeimg.com/640/480/any'),
                        fit: BoxFit.fill,
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text('Title'),
                          subtitle: Text('Subtitle'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
        ],
      );

  Widget buildRecipesView() => CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                onTap: () => {},
                title: Text(
                  'Công thức nấu ăn từ cộng đồng',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                  ),
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
                  itemBuilder: (BuildContext context, int index) => new Card(
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
                                color: Colors.black.withAlpha(0),
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
                  'Công thức yêu thích của bạn',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'OpenSans'),
                ),
                trailing: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
          SliverList(delegate: SliverChildBuilderDelegate(
            (_, int index) {
              return Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  height: 70,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image(
                        image: NetworkImage('https://placeimg.com/640/480/any'),
                        fit: BoxFit.fill,
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text('Title'),
                          subtitle: Text('Subtitle'),
                        ),
                      ),
                    ],
                  ),
                ),
                elevation: 1,
              );
            },
          )),
        ],
      );
}
