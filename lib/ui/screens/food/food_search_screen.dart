import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_state.dart';
import 'package:calories/models/models.dart';
import 'package:calories/pop_with_result.dart';
import 'package:calories/ui/screens/food/food_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodSearchArgument {
  final FoodAction action;

  FoodSearchArgument({this.action});
}

class FoodSearchScreen extends StatefulWidget {
  static final String routeName = '/foodSearch';

  @override
  State<StatefulWidget> createState() => new FoodSearchScreenState();
}

class FoodSearchScreenState extends State<FoodSearchScreen> {
  static final String routeName = '/foodSearch';
  FoodAction _action;
  String _searchQuery;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _onFilterPress(BuildContext pcontext) {
    showDialog(
        context: pcontext,
        builder: (BuildContext context) {
          return _filterDialog();
        });
  }

  Widget _filterDialog() {
    return AlertDialog(
      contentPadding: EdgeInsets.all(15),
      titleTextStyle: TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 4,
          children: List<Widget>.generate(
            50,
            (int index) {
              return ChoiceChip(
                pressElevation: 0.0,
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey[100],
                label: Text("item $index"),
                selected: false,
              );
            },
          ).toList(),
        ),
      ),
      title: Text('Chọn các bộ lọc'),
      actions: <Widget>[
        FlatButton(
          child: Text('Đóng'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            titleSpacing: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.grey[100],
            title: TextField(
              autofocus: true,
              style: TextStyle(fontSize: 18),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration.collapsed(
                hintStyle: TextStyle(fontSize: 18),
                hintText: 'Enter food name',
              ),
            ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                  ),
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
                if (state is FoodLoading) {
                  return SliverToBoxAdapter(
                    child: Text("Loading"),
                  );
                } else if (state is FoodLoaded) {
                  final allFoods = state.foods;
                  var foods;
                  if (_searchQuery == null || _searchQuery == '')
                    foods = allFoods;
                  else {
                    foods = allFoods
                        .where((e) => e.name
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                        .toList();
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final food = foods[index];
                        return Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            height: 75,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image(
                                  image: NetworkImage(
                                      'https://placeimg.com/640/480/any'),
                                  fit: BoxFit.fill,
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(food.name),
                                    onTap: () => _onListTileTapped(food),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: foods.length,
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: Text("Cannot load foods"),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _onListTileTapped(Food food) {
    if (_action == null || _action == FoodAction.NO_ACTION) {
      Navigator.pushNamed(context, FoodDetailScreen.routeName,
          arguments: FoodDetailArgument(food: food));
    } else {
      Navigator.pushNamed(
        context,
        FoodDetailScreen.routeName,
        arguments: FoodDetailArgument(
          food: food,
          action: _action,
        ),
      ).then((r) {
        if (r is PopWithResults) {
          if (r.toPage == routeName) {
            return;
          } else {
            Navigator.pop(context, r);
          }
        }
      });
    }
  }
}
