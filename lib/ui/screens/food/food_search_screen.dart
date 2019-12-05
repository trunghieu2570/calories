import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_state.dart';
import 'package:calories/models/models.dart';
import 'package:calories/pop_with_result.dart';
import 'package:calories/ui/screens/food/food_detail_screen.dart';
import 'package:flutter/material.dart';
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
  bool _isEditing = false;
  FoodAction _action;

  List<Widget> _buildActions(bool isEditing) {
    if (isEditing)
      return [
        Container(
          margin: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
          color: Colors.grey[100],
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => {},
          ),
        ),
      ];
    return [
      IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: () => _onFilterPress(context),
      ),
      IconButton(
        icon: Icon(Icons.mic_none),
        onPressed: () => {},
      ),
    ];
  }

  Widget _buildLeading(bool isEditing) {
    if (isEditing)
      return Container(
        margin: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
        color: Colors.grey[100],
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _cancelEditing,
        ),
      );
    return Container(
      margin: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _onSearchBarTapped() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
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

  Widget _layoutStack() => CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            forceElevated: true,
            centerTitle: true,
            titleSpacing: 0.0,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                onTap: _onSearchBarTapped,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: 'Nhập tên thực phẩm bạn cần tìm',
                ),
              ),
            ),
            leading: _buildLeading(_isEditing),
            actions: _buildActions(_isEditing),
          ),
          BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
            if (state is FoodLoading) {
              return SliverToBoxAdapter(
                child: Text("Loading"),
              );
            } else if (state is FoodLoaded) {
              final foods = state.foods;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final food = foods[index];
                    return Card(
                      elevation: 0,
                      child: Container(
                        child: ListTile(
                          onTap: () => _onListTileTapped(foods[index]),
                          title: Text(
                            food.name,
                          ),
                          subtitle: Text(
                            food.brand,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: foods.length,
                ),
              );
            }
            return SliverToBoxAdapter(
              child: Text("Can't load foods list"),
            );
          }),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final FoodSearchArgument args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      _action = args.action;
    }
    return Scaffold(
      body: _layoutStack(),
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
