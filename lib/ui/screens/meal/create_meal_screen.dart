import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_state.dart';
import 'package:calories/blocs/meal/bloc.dart';
import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_state.dart';
import 'package:calories/models/models.dart';
import 'package:calories/ui/screens/food/food_detail_screen.dart';
import 'package:calories/ui/screens/recipe/recipe_detail_screen.dart';
import 'package:calories/ui/screens/recipe/recipe_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../pop_with_result.dart';
import '../food/food_search_screen.dart';

class CreateMealScreen extends StatefulWidget {
  static final String routeName = '/createMeal';

  @override
  State<StatefulWidget> createState() {
    return CreateMealScreenState();
  }
}

class CreateMealScreenState extends State<CreateMealScreen> {
  static final String routeName = '/createMeal';
  String _name;
  String _photoUrl;
  List<MealItem> _items;
  final _formKey = GlobalKey<FormState>();
  FoodBloc _foodBloc;
  RecipeBloc _recipeBloc;
  MealBloc _mealBloc;

  @override
  void initState() {
    super.initState();
    _items = List<MealItem>();
    _foodBloc = BlocProvider.of<FoodBloc>(context);
    _recipeBloc = BlocProvider.of<RecipeBloc>(context);
    _mealBloc = BlocProvider.of<MealBloc>(context);
  }

  void _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Meal meal = Meal(_name, items: _items, tags: [], photoUrl: null);
      _mealBloc.add(AddMeal(meal));
      Navigator.popUntil(context, ModalRoute.withName("/"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Create new meal"),
        actions: <Widget>[
          FlatButton(
            onPressed: _onSave,
            child: Text("SAVE"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: "Name"),
                      onSaved: (value) => _name = value,
                      validator: (value) {
                        if (value.isEmpty) return "This field is required";
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  final foodState = _foodBloc.state;
                  final recipeState = _recipeBloc.state;
                  if (foodState is FoodLoaded && recipeState is RecipesLoaded) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, int index) {
                        final item = _items[index];
                        if (item.type == MealItemType.FOOD) {
                          try {
                            final food = foodState.foods
                                .where((e) => e.id == item.itemId)
                                .first;
                            return ListTile(
                              title: Text(food.name),
                              subtitle: Text(item.quantity.toString()),
                            );
                          } catch (StateError) {
                            return Container();
                          }
                        } else if (item.type == MealItemType.RECIPE) {
                          try {
                            final recipe = recipeState.recipes
                                .where((e) => e.id == item.itemId)
                                .first;
                            return ListTile(
                              title: Text(recipe.title),
                              subtitle: Text(item.quantity.toString()),
                            );
                          } catch (StateError) {
                            return Container();
                          }
                        } else
                          return Container();
                      },
                      itemCount: _items.length,
                    );
                  }
                  return Container();
                },
              ),
              RaisedButton(
                onPressed: _onAddButtonPressed,
                child: Text("Add item"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onAddButtonPressed() async {
    _showDialog(context);
  }

  Future<void> _showDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.all(0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text("Add food"),
                    onTap: _onAddFoodTapped,
                  ),
                  ListTile(
                    title: Text("Add recipe"),
                    onTap: _onAddRecipeTapped,
                  ),
                ],
              )
            ));
  }

  Future<void> _onAddFoodTapped() async {
    Navigator.pop(context);
    Navigator.pushNamed(context, FoodSearchScreen.routeName,
            arguments: FoodSearchArgument(action: FoodAction.ADD_TO_MEAL))
        .then((result) {
      if (result is PopWithResults) {
        if (result.toPage == routeName) {
          final item = MealItem(
            result.results['foodId'] as String,
            MealItemType.FOOD,
            result.results['quantity'] as String,
          );
          _items.add(item);

        }
      }
    });
  }

  Future<void> _onAddRecipeTapped() async {
    Navigator.pop(context);
    Navigator.pushNamed(context, RecipeSearchScreen.routeName,
            arguments: RecipeSearchArgument(action: RecipeAction.ADD_TO_MEAL))
        .then((result) {
      if (result is PopWithResults) {
        if (result.toPage == routeName) {
          final item = MealItem(
            result.results["recipeId"] as String,
            MealItemType.RECIPE,
            result.results["quantity"] as String,
          );
          _items.add(item);
        }
      }
    });
  }
}
