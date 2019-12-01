import 'package:calories/ui/widgets/donut_chart.dart';
import 'package:flutter/material.dart';

import '../util.dart';

class DiaryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new DiaryScreenState();
}

class DiaryScreenState extends State<DiaryScreen> {
  String _pageTitle = "Hôm nay";
  PageController _pageController;

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

  void _changePageByDate(DateTime date) {
    var index = getIndexFromDate(date);
    _pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(
      initialPage: getIndexFromDate(DateTime.now()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool headerSliverBuilder) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: false,
              //expandedHeight: 120,
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
              return pageViewItem(index);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        tooltip: 'Thêm vào nhật ký',
        icon: Icon(Icons.add),
        label: Text("THÊM"),
      ),
    );
  }
}

final sessions = ['Buổi sáng', 'Buổi trưa', 'Buổi chiều', 'Ăn vặt'];
final items = ['Món ăn A', 'Món ăn B', 'Món ăn C', 'Đồ uống A'];

Widget sessionItem(Color color, int titleID) => Center(
      child: Card(
        elevation: 0,
        borderOnForeground: true,
        /*shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey[400]),
        ),*/
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              child: Text(
                sessions[titleID],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: "OpenSans"),
              ),
            ),
            Divider(),
            Column(children: items.map((item) => listItem(item)).toList()),
          ],
        ),
      ),
    );

Widget listItem(String item) => ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.indigo,
        child: Text(item[0]),
      ),
      title: Text(item),
      subtitle: Text("250g"),
    );

Widget pageViewItem(int index) => CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                padding: EdgeInsets.all(20),
                child: DonutChart(),
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
                    onPressed: () => {},
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
                    onPressed: () => {},
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
                    onPressed: () => {},
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
                            onPressed: () {
                              /* ... */
                            },
                          ),
                          FlatButton(
                            child: const Text('Chỉnh sửa mục tiêu'),
                            onPressed: () {
                              /* ... */
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverList(
          ///Use SliverChildListDelegate and provide a list
          ///of widgets if the count is limited
          ///
          ///Lazy building of list
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              /// To convert this infinite list to a list with "n" no of items,
              /// uncomment the following line:
              /// if (index > n) return null;
              return sessionItem(Colors.blueGrey, index);
            },
            childCount: 4,

            /// Set childCount to limit no.of items
            /// childCount: 100,
          ),
        ),
      ],
    );
