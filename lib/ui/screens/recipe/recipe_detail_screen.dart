import 'package:calories/blocs/favorite_recipes/favorite_recipes_bloc.dart';
import 'package:calories/blocs/favorite_recipes/favorite_recipes_event.dart';
import 'package:calories/blocs/favorite_recipes/favorite_recipes_state.dart';
import 'package:calories/blocs/food/bloc.dart';
import 'package:calories/models/models.dart';
import 'package:calories/pop_with_result.dart';
import 'package:calories/ui/screens/meal/create_meal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum RecipeAction {
  ADD_TO_MEAL,
  ADD_TO_DIARY,
  NO_ACTION,
}

class RecipeDetailArgument {
  final Recipe recipe;
  final RecipeAction action;

  RecipeDetailArgument({@required this.recipe, this.action})
      : assert(recipe != null);
}

class RecipeDetailScreen extends StatefulWidget {
  static final String routeName = '/recipeDetail';

  @override
  State<StatefulWidget> createState() => new _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Recipe _recipe;

  FavoriteRecipesBloc _favoriteRecipesBloc;
  RecipeAction _recipeAction;
  TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCity = _dropDownMenuItems[0].value;
    _favoriteRecipesBloc = BlocProvider.of<FavoriteRecipesBloc>(context);
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
    final RecipeDetailArgument args = ModalRoute.of(context).settings.arguments;
    _recipe = args.recipe;
    _recipeAction = args.action;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: <Widget>[
          BlocBuilder<FavoriteRecipesBloc, FavoriteRecipesState>(
              builder: (context, state) {
            if (state is FavoriteRecipesLoaded) {
              final _isFavorite = state.recipeIds.contains(_recipe.id);
              return IconButton(
                icon: _isFavorite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () {
                  if (_isFavorite) {
                    Scaffold.of(context).removeCurrentSnackBar();
                    _favoriteRecipesBloc.add(DeleteFavoriteRecipe(_recipe.id));
                    final snackBar = SnackBar(
                      content: Text('Đã loại bỏ yêu thích'),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  } else {
                    Scaffold.of(context).removeCurrentSnackBar();
                    _favoriteRecipesBloc.add(AddFavoriteRecipe(_recipe.id));
                    final snackBar = SnackBar(
                      content: Text('Đã thêm vào yêu thích'),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                },
              );
            }
            return Container();
          }),
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
          'Chi tiết công thức nấu ăn',
          style: TextStyle(color: Colors.black),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
          if (state is FoodLoaded) {
            final foods = state.foods;
            return Column(
              children: <Widget>[
                Card(
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
                              _recipe.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  //color: Colors.white,
                                  fontFamily: "OpenSans"),
                            ),
                            Text(
                              _recipe.numberOfServings.toString(),
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
                Card(
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
                Card(
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
                          'Thành phần',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: "OpenSans"),
                        ),
                      ),
                      Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (_, int index) {
                          final ingredient = _recipe.ingredients[index];
                          final food = foods
                              .where((food) => food.id == ingredient.foodId)
                              .first;
                          return ListTile(
                            title: Text(
                              food.name,
                            ),
                            subtitle: Text(
                                ingredient.quantity + " " + food.servings.unit),
                          );
                        },
                        itemCount: _recipe.ingredients.length,
                      )
                    ],
                  ),
                ),
                Card(
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
                          'Quy trình nấu',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: "OpenSans"),
                        ),
                      ),
                      Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (_, int index) {
                          final direction = _recipe.directions[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                index.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            title: Text(
                              direction,
                            ),
                          );
                        },
                        itemCount: _recipe.directions.length,
                      )
                    ],
                  ),
                )
              ],
            );
          }
          return Text("No connection");
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddButtonPressed,
        label: Text('Thêm vào'),
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
                    controller: _quantityController,
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

  Future<void> _onAddButtonPressed() async {

    switch(_recipeAction) {
      case RecipeAction.ADD_TO_MEAL:
        Navigator.pop(
            context,
            PopWithResults(
                fromPage: RecipeDetailScreen.routeName,
                toPage: CreateMealScreen.routeName,
                results: {
                  'recipeId': '${_recipe.id}',
                  'quantity': '${_quantityController.text}'
                }));
        break;
      case RecipeAction.ADD_TO_DIARY:
      // TODO: Handle this case.
        break;
      case RecipeAction.NO_ACTION:
      // TODO: Handle this case.
        break;
    }
  }
}
