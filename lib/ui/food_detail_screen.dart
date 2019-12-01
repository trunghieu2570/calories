import 'package:calories/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FoodDetail extends StatefulWidget {
  final Food food;

  const FoodDetail({Key key, @required this.food}) : assert(food != null);

  @override
  State<StatefulWidget> createState() => new FoodDetailState(food: food);
}

class FoodDetailState extends State<FoodDetail> {
  final Food food;

  FoodDetailState({this.food});

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCity = _dropDownMenuItems[0].value;
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _cities) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  List _cities = [
    "Cluj-Napoca",
    "Bucuresti",
    "Timisoara",
    "Brasov",
    "Constanta"
  ];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () => {},
          ),
        ],
        title: Text(
          'Chi tiết thực phẩm',
          style: TextStyle(color: Colors.black),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Flexible(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Card(
                    elevation: 0,
                    //color: Colors.orange,
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.4),
                      borderRadius: new BorderRadius.circular(10),
                    ),

                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                food.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    //color: Colors.white,
                                    fontFamily: "OpenSans"),
                              ),
                              Text(
                                food.brand,
                                style: TextStyle(
                                    fontSize: 20,
                                    //color: Colors.white,
                                    fontFamily: "OpenSans"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Card(
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
                            'Thông tin dinh dưỡng',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: "OpenSans"),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            'Chất đạm',
                          ),
                          trailing: Text('40'),
                        ),
                        ListTile(
                          title: Text(
                            'Chất béo',
                          ),
                          trailing: Text('20g'),
                        ),
                        ListTile(
                          title: Text(
                            'Tinh bột',
                          ),
                          trailing: Text('250g'),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {},
        label: Text('Thêm vào Bữa trưa'),
        icon: Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        decoration: new BoxDecoration(color: Theme.of(context).cardColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Divider(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  // width: 30,
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_up),
                    padding: EdgeInsets.all(0.0),
                    //padding: EdgeInsets.symmetric(horizontal: 1),
                    onPressed: () => {},
                  ),
                  //padding: EdgeInsets.symmetric(horizontal: 2.0),
                ),
                Container(
                  //padding: EdgeInsets.symmetric(horizontal: 8.0),
                  width: 60,
                  child: new TextField(
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      //filled: true,
                      //fillColor: Colors.grey[100],
                      hintText: 'SL',
                    ),
                  ),
                ),
                Container(
                  //width: 30,
                  child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: () => {},
                  ),
                  //padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButton(
                      isExpanded: true,
                      hint: Text('Select'),
                      value: _currentCity,
                      items: _dropDownMenuItems,
                      onChanged: (str) => setState(() {
                        _currentCity = str;
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
