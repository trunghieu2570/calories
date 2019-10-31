import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'views/diary_view.dart' as DiaryView;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          textTheme: TextTheme(
              title: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "OpenSans",
          ))),
      home: MyHomePage(title: 'Hôm nay'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  MyHomePageState createState() => MyHomePageState();
}

String getDate(int index) {
  var firstDate = DateTime(1900);
  var date = firstDate.add(new Duration(days: index));
  return "${date.day} Thg ${date.month} ${date.year}";
}

int getIndexFromDate(DateTime date) {
  var firstDate = DateTime(1900);
  var result = date.difference(firstDate);
  return result.inDays;
}

class MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int _counter = 0;
  String _pageTitle = "Hôm nay";
  PageController _pageController;
  TabController _foodTabController;
  int _selectedView = 0;

  List<Widget> _views;

  SystemUiOverlayStyle systemUiOverlayStyle = new SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.grey[50],
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.black54,
  );

  Future<Null> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      initialDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _changePageByDate(picked);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = new PageController(
      initialPage: getIndexFromDate(DateTime.now()),
    );
    _foodTabController = new TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
    _reset();
    _selectedView = 0;
  }

  void _onPageChanged(int index) {
    setState(() {
      var todayIndex = getIndexFromDate(DateTime.now());
      print("page $todayIndex changed to $index");
      if (index == todayIndex) {
        _pageTitle = "Hôm nay";
      } else if (index == todayIndex - 1) {
        _pageTitle = "Hôm qua";
      } else if (index == todayIndex + 1) {
        _pageTitle = "Ngày mai";
      } else {
        _pageTitle = getDate(index);
      }
      print(" Page title: $_pageTitle");
    });
  }

  void _reset() {
    setState(() {
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    });
  }

  void _changeView(int index) {
    setState(() {
      _selectedView = index;
    });
  }

  void _changePageByDate(DateTime date) {
    var index = getIndexFromDate(date);
    _pageController.jumpToPage(index);
  }

  Future<Null> _nextPage() async {
    _pageController.nextPage(
      curve: Curves.linear,
      duration: kTabScrollDuration,
    );
  }

  Future<Null> _prevPage() async {
    _pageController.previousPage(
      curve: Curves.linear,
      duration: kTabScrollDuration,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _reset();
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.suspending:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _views = [
      NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool headerSliverBuilder) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: false,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 15.0, bottom: 5),
                title: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () => _selectDate(context),
                  child: Text(
                    _pageTitle,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_left),
                  onPressed: () => _prevPage(),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: () => _nextPage(),
                )
              ],
            ),
          ];
        },
        body: PageView.custom(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return DiaryView.pageViewItem(index);
            },
          ),
        ),
      ),
      NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool headerSliverBuilder) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: false,
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
                )
              ],
              bottom: TabBar(
                controller: _foodTabController,
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
          controller: _foodTabController,
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
      Text("Hello World 3"),
      Text("Hello World 4"),
    ];
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return _views.elementAt(_selectedView);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        icon: Icon(Icons.add),
        label: Text("THÊM"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            title: Text("Nhật ký"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining),
            title: Text("Đồ ăn"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            title: Text("Mục tiêu"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            title: Text("Hồ sơ"),
          ),
        ],
        onTap: _changeView,
        currentIndex: _selectedView,
      ),
    );
  }
}
