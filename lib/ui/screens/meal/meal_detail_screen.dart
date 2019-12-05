import 'package:calories/blocs/favorite_meals/bloc.dart';
import 'package:calories/blocs/food/bloc.dart';
import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_state.dart';
import 'package:calories/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MealAction {
  ADD_TO_DIARY,
}

class MealDetailArgument {
  final Meal meal;
  final MealAction action;

  MealDetailArgument({@required this.meal, this.action}) : assert(meal != null);
}

class MealDetailScreen extends StatefulWidget {
  static final String routeName = '/mealDetail';

  @override
  State<StatefulWidget> createState() => new _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Meal _meal;
  FavoriteMealsBloc _favoriteMealsBloc;

  //MealAction _mealAction;

  @override
  void initState() {
    super.initState();
    _favoriteMealsBloc = BlocProvider.of<FavoriteMealsBloc>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  Widget build(BuildContext context) {
    final MealDetailArgument args = ModalRoute
        .of(context)
        .settings
        .arguments;
    _meal = args.meal;
    //_mealAction = args.action;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: <Widget>[
          BlocBuilder<FavoriteMealsBloc, FavoriteMealsState>(
              builder: (context, state) {
            if (state is FavoriteMealsLoaded) {
              final _isFavorite = state.mealIds.contains(_meal.id);
              return IconButton(
                icon: _isFavorite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () {
                  if (_isFavorite) {
                    Scaffold.of(context).removeCurrentSnackBar();
                    _favoriteMealsBloc.add(DeleteFavoriteMeal(_meal.id));
                    final snackBar = SnackBar(
                      content: Text('Đã loại bỏ yêu thích'),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  } else {
                    Scaffold.of(context).removeCurrentSnackBar();
                    _favoriteMealsBloc.add(AddFavoriteMeal(_meal.id));
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
          'Chi tiết bua an',
          style: TextStyle(color: Colors.black),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: BlocBuilder<FoodBloc, FoodState>(
          builder: (context, foodState) {
            return BlocBuilder<RecipeBloc, RecipeState>(
                builder: (context, recipeState) {
                  if (foodState is FoodLoaded && recipeState is RecipesLoaded) {
                    final foods = foodState.foods;
                    final recipes = recipeState.recipes;
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
                                      _meal.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
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
                                  final item = _meal.items[index];
                                  if (item.type == MealItemType.FOOD) {
                                    try {
                                      final food = foods.firstWhere(
                                              (food) => food.id == item.itemId);
                                      return ListTile(
                                        title: Text(
                                          food.name,
                                        ),
                                        subtitle: Text(
                                          food.brand,
                                        ),
                                      );
                                    } catch (StateError) {
                                      return Container();
                                    }
                                  } else if (item.type == MealItemType.RECIPE) {
                                    try {
                                      final recipe = recipes
                                          .firstWhere((e) =>
                                      e.id == item.itemId);
                                      return ListTile(
                                        title: Text(
                                          recipe.title,
                                        ),
                                        subtitle: Text(
                                          recipe.numberOfServings.toString() +
                                              " serving(s)",
                                        ),
                                      );
                                    } catch (StateError) {
                                      return Container();
                                    }
                                  }
                                  return Container();
                                },
                                itemCount: _meal.items.length,
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddButtonPressed,
        label: Text('Thêm vào'),
        icon: Icon(Icons.add),
      ),
    );
  }

  Future<void> _onAddButtonPressed() async {
    /*if (_foodAction == FoodAction.ADD_TO_RECIPE) {
      Navigator.pop(
          context,
          PopWithResults(
              fromPage: FoodDetailScreen.routeName,
              toPage: CreateRecipeScreen.routeName,
              results: {
                'foodId': '${_food.id}',
                'quantity': '${_quantityController.text}'
              }));
    }*/
  }
}
