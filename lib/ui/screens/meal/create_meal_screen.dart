import 'dart:io';

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
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
  File _photo;
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

  Future _pickImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = img;
    });
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
        body: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    height: 300,
                    child: Scaffold(
                      backgroundColor: Colors.grey,
                      floatingActionButton: FloatingActionButton(
                        onPressed: _pickImage,
                        child: Icon(Icons.camera_alt),
                      ),
                      body: Container(
                        decoration: _photo != null
                            ? BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(_photo),
                          ),
                        )
                            : (_photoUrl != null
                            ? BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(_photoUrl)),
                        )
                            : null),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Meal name",
                      ),
                      onSaved: (value) => _name = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),

                  Builder(
                    builder: (context) {
                      final foodState = _foodBloc.state;
                      final recipeState = _recipeBloc.state;
                      if (foodState is FoodLoaded && recipeState is RecipesLoaded) {
                        return Card(
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
                                  "Items",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      fontFamily: "OpenSans"),
                                ),
                              ),
                              Divider(),
                              ListView.builder(
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (_, int index) {
                                  final item = _items[index];
                                  if (item.type == MealItemType.FOOD) {
                                    try {
                                      final food =
                                      foodState.foods.firstWhere((food) => food.id == item.itemId);
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
                                      final recipe = recipeState.recipes.firstWhere((e) => e.id == item.itemId);
                                      return ListTile(
                                        title: Text(
                                          recipe.title,
                                        ),
                                        subtitle: Text(
                                          recipe.numberOfServings.toString() + " serving(s)",
                                        ),
                                      );
                                    } catch (StateError) {
                                      return Container();
                                    }
                                  }
                                  return Container();
                                },
                                itemCount: _items.length,
                              )
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  RaisedButton(
                    onPressed: _onAddButtonPressed,
                    child: Text("Add item"),
                  )
                ]),
              ),

            ],
          ),
        ));
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
            )));
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
