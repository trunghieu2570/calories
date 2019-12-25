import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calories/blocs/auth/bloc.dart';
import 'package:calories/blocs/favorite_meals/bloc.dart';
import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_state.dart';
import 'package:calories/blocs/meal/bloc.dart';
import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_state.dart';
import 'package:calories/models/models.dart';
import 'package:calories/ui/screens/food/food_detail_screen.dart';
import 'package:calories/ui/screens/recipe/recipe_detail_screen.dart';
import 'package:calories/ui/screens/recipe/recipe_search_screen.dart';
import 'package:calories/ui/widgets/loading_stack_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../pop_with_result.dart';
import '../food/food_search_screen.dart';

class CreateMealScreen extends StatefulWidget {
  final Meal meal;
  static final String routeName = '/createMeal';

  CreateMealScreen({this.meal});

  @override
  State<StatefulWidget> createState() {
    return _CreateMealScreenState(meal);
  }
}

class _CreateMealScreenState extends State<CreateMealScreen> {
  static final String routeName = '/createMeal';
  final Meal oldMeal;
  final _formKey = GlobalKey<FormState>();
  String _name;
  File _photo;
  String _photoUrl;
  bool _share = true;
  String _uid;
  List<MealItem> _items;
  FoodBloc _foodBloc;
  RecipeBloc _recipeBloc;
  AuthBloc _authBloc;
  FavoriteMealsBloc _favoriteMealsBloc;
  MealBloc _mealBloc;
  bool _isLoading = false;

  _CreateMealScreenState(this.oldMeal);

  @override
  void initState() {
    super.initState();
    _items = List<MealItem>();
    _foodBloc = BlocProvider.of<FoodBloc>(context);
    _recipeBloc = BlocProvider.of<RecipeBloc>(context);
    _mealBloc = BlocProvider.of<MealBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _favoriteMealsBloc = BlocProvider.of<FavoriteMealsBloc>(context);
    if (oldMeal != null) {
      _uid = oldMeal.creatorId;
      _share = oldMeal.share ?? true;
      _name = oldMeal.name;
      _photoUrl = oldMeal.photoUrl;
      _items = oldMeal.items;
    }
  }

  void _setLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  void _onSave() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _setLoadingState(true);
      final authState = _authBloc.state;
      if (authState is Authenticated) {
        String photoUrl;
        if (_photo != null) photoUrl = await _uploadImage(_photo);
        if (oldMeal != null) {
          //edit
          Meal newMeal = oldMeal.copyWith(
              items: _items, photoUrl: photoUrl, name: _name, share: _share);
          _mealBloc.add(UpdateMeal(newMeal));
          Navigator.pop(context, newMeal);
        } else {
          //create new
          _uid = authState.user.uid;
          print(photoUrl);
          Meal newMeal = Meal(_name,
              creatorId: _uid,
              share: _share,
              items: _items,
              tags: [],
              photoUrl: photoUrl);
          _mealBloc.add(AddMeal(newMeal));
          Navigator.popUntil(context, ModalRoute.withName("/"));
        }
      }
      _setLoadingState(false);
    }
  }

  Future _pickImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = img;
    });
  }

  ///Upload image
  Future<String> _uploadImage(File image) async {
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(image.hashCode.toString())
        .child("image.jpg");
    StorageUploadTask uploadTask = ref.putFile(image);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingStack(
      body: _buildBody(),
      state: _isLoading,
    );
  }

  Widget _buildBody() => Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(oldMeal != null ? 'Edit Meal' : 'Create Meal'),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () => _onSave(),
              child: Text('Save'.toUpperCase()),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
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
                                          image: CachedNetworkImageProvider(
                                              _photoUrl)),
                                    )
                                  : null),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        initialValue: _name,
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
                        if (foodState is FoodLoaded &&
                            recipeState is RecipesLoaded) {
                          if (_items.isEmpty) {
                            return Card(
                              elevation: 0,
                              borderOnForeground: true,
                              margin: EdgeInsets.all(5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    title: Text(
                                      "Items List",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          fontFamily: "OpenSans"),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Colors.black,
                                      ),
                                      onPressed: _onAddButtonPressed,
                                    ),
                                  ),
                                  Divider(),
                                  ListTile(
                                    onTap: _onAddButtonPressed,
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Tap '),
                                        Icon(Icons.add_circle),
                                        Text(' to add foods or recipes'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Card(
                              elevation: 0,
                              borderOnForeground: true,
                              margin: EdgeInsets.all(5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      "Items List",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          fontFamily: "OpenSans"),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.add_circle_outline),
                                      onPressed: _onAddButtonPressed,
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
                                          final food = foodState.foods
                                              .firstWhere((food) =>
                                                  food.id == item.itemId);
                                          return ListTile(
                                            title: Text(
                                              food.name,
                                            ),
                                            subtitle: Text(
                                              food.brand,
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.grey[700],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _items.removeAt(index);
                                                });
                                              },
                                            ),
                                          );
                                        } catch (err) {
                                          return Container();
                                        }
                                      } else if (item.type ==
                                          MealItemType.RECIPE) {
                                        try {
                                          final recipe = recipeState.recipes
                                              .firstWhere(
                                                  (e) => e.id == item.itemId);
                                          return ListTile(
                                            title: Text(
                                              recipe.title,
                                            ),
                                            subtitle: Text(
                                              recipe.numberOfServings
                                                      .toString() +
                                                  " serving(s)",
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.grey[700],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _items.removeAt(index);
                                                });
                                              },
                                            ),
                                          );
                                        } catch (err) {
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
                        }
                        return Container();
                      },
                    ),
                    ListTile(
                      title: Text('Share to community'),
                      trailing: Switch(
                        onChanged: (v) {
                          setState(() {
                            _share = v;
                          });
                        },
                        value: _share,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

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
