import 'package:flutter/material.dart';
import 'package:calories/components/donut_chart.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

GlobalKey<DonutChartState> globalKey = GlobalKey();

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

class MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int _counter = 0;
  SystemUiOverlayStyle systemUiOverlayStyle = new SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.grey[50],
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.black54,
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    reset();
  }

  void reset() {
    setState(() {
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        reset();
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
    setState(() {
      globalKey.currentState.playAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: false,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 15.0, bottom: 5),
              title: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () => {},
                child: Text(
                  widget.title,
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
                onPressed: () => _incrementCounter(),
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () => _incrementCounter(),
              )
            ],
          ),
          SliverToBoxAdapter(
              child: Column(
            children: <Widget>[
              Container(
                height: 300,
                padding: EdgeInsets.all(20),
                child: DonutChart(
                  key: globalKey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "2630",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: "OpenSans",
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Calo đã nạp",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "OpenSans",
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => _incrementCounter(),
                  ),
                  FlatButton(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "2.5L",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: "OpenSans",
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Nước đã uống",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "OpenSans",
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => _incrementCounter(),
                  ),
                ],
              ),
              Divider(
                height: 20,
              ),
              Row(
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
                          "CHẤT BÉO",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "60g",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => _incrementCounter(),
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "TINH BỘT",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "210g",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => _incrementCounter(),
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "CHẤT ĐẠM",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "60g",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => _incrementCounter(),
                  ),
                ],
              ),
              Card(
                elevation: 0,
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey[400]),
                ),
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Mục tiêu hằng ngày",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "OpenSans"),
                      ),
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.panorama_fish_eye,
                              color: Colors.green,
                              size: 12,
                            ),
                            Text("\tUống đủ 2 lít nước."),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 12,
                            ),
                            Text("\tĂn đủ 2600 calo."),
                            Text(
                              "\t(Đã hoàn thành)",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.panorama_fish_eye,
                              color: Colors.green,
                              size: 12,
                            ),
                            Text("\tĂn dưới 60 gram chất béo"),
                            Text(
                              "\t(25g còn lại)",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ButtonTheme.bar(
                      // make buttons use the appropriate styles for cards
                      child: ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('Bỏ qua'),
                            onPressed: () {/* ... */},
                          ),
                          FlatButton(
                            child: const Text('Chỉnh sửa mục tiêu'),
                            onPressed: () {/* ... */},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
              ),
            ],
          )),
        ],
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
            icon: Icon(Icons.subject),
            title: Text("Menu"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            title: Text("Hồ sơ"),
          ),
        ],
      ),
    );
  }
}
