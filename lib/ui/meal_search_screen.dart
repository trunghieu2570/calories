import 'package:calories/blocs/meal/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MealSearchAction { SEARCH_FOR_DIARY }

class MealSearchArgument {
  final MealSearchAction mealSearchAction;

  MealSearchArgument({this.mealSearchAction});
}

class MealSearchScreen extends StatefulWidget {
  static final String routeName = "/mealSearch";
  @override
  _MealSearchScreenState createState() => _MealSearchScreenState();
}

class _MealSearchScreenState extends State<MealSearchScreen> {
  static final String routeName = "/mealSearch";
  bool _isEditing = false;
  MealSearchAction _action;

  List<Widget> _buildActions(bool isEditting) {
    if (isEditting)
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
                  hintText: 'Nhập tên bữa ăn bạn cần tìm',
                ),
              ),
            ),
            leading: _buildLeading(_isEditing),
            actions: _buildActions(_isEditing),
          ),
          BlocBuilder<MealBloc, MealState>(builder: (context, state) {
            if (state is MealsLoading) {
              return SliverToBoxAdapter(
                child: Text("Loading"),
              );
            } else if (state is MealsLoaded) {
              final meals = state.meals;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final meal = meals[index];
                    return Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        height: 75,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            /*Image(
                              image: NetworkImage(
                                  'https://placeimg.com/640/480/any'),
                              fit: BoxFit.fill,
                            ),*/
                            Expanded(
                              child: ListTile(
                                title: Text(meal.name),
                                onTap: () => {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: meals.length,
                ),
              );
            }
            return SliverToBoxAdapter(
              child: Text("Cannot load meals"),
            );
          }),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _layoutStack(),
    );
  }

/*  Future<void> _onRecipeTapped(Recipe recipe)  async{
    Navigator.pushNamed(context, RecipeDetailScreen.routeName, arguments: RecipeDetailArgument(recipe: recipe));
  }*/
}
