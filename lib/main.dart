import 'package:flutter/material.dart';
import 'package:calories/components/donut_chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '27, Tháng 10'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
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
              titlePadding: EdgeInsets.all(18.0),
              title: Text(
                widget.title,
                style: TextStyle(color: Colors.black),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            brightness: Brightness.light,
            actions: <Widget>[
              IconButton(
                color: Colors.black,
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () => _incrementCounter(),
              ),
              IconButton(
                color: Colors.black,
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () => _incrementCounter(),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
                height: 300, padding: EdgeInsets.all(20), child: DonutChart()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.subject, color: Colors.black),
            title: Text("Menu"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subject, color: Colors.black),
            title: Text("Menu"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subject, color: Colors.black),
            title: Text("Menu"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subject, color: Colors.black),
            title: Text("Menu"),
          ),
        ],
      ),
    );
  }
}
