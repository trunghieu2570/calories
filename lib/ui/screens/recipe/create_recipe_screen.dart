import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calories/blocs/auth/bloc.dart';
import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_state.dart';
import 'package:calories/models/models.dart';
import 'package:calories/pop_with_result.dart';
import 'package:calories/ui/screens/recipe/edit_recipe_directions_screen.dart';
import 'package:calories/ui/screens/food/food_detail_screen.dart';
import 'package:calories/ui/screens/food/food_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateRecipeScreen extends StatefulWidget {
  static final String routeName = '/createRecipe';
  final Recipe recipe;

  CreateRecipeScreen({this.recipe});

  @override
  State<StatefulWidget> createState() {
    return _CreateRecipeScreenState(recipe);
  }
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  static final String routeName = '/createRecipe';
  final Recipe oldRecipe;
  String _title;
  int _numberOfServings = 0;
  File _photo;
  String _photoUrl;
  String _uid;
  bool _share = true;
  List<Ingredient> _ingredients;
  final _formKey = GlobalKey<FormState>();
  AuthBloc _authBloc;

  _CreateRecipeScreenState(this.oldRecipe);

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _ingredients = List<Ingredient>();
    if (oldRecipe != null) {
      _title = oldRecipe.title;
      _numberOfServings = oldRecipe.numberOfServings;
      _photoUrl = oldRecipe.photoUrl;
      _uid = oldRecipe.creatorId;
      _share = oldRecipe.share ?? true;
      _ingredients = oldRecipe.ingredients;
    }
  }

  void _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final authState = _authBloc.state;
      if (authState is Authenticated) {
        if (oldRecipe != null) {
          Recipe recipe = oldRecipe.copyWith(
            title: _title,
            numberOfServings: _numberOfServings,
            share: _share,
            ingredients: _ingredients,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return EditRecipeDirectionsScreen(
                recipe: recipe,
                photo: _photo,
              );
            }),
          ).then((editedRecipe) => Navigator.pop(context, editedRecipe));
        } else {
          _uid = authState.user.uid;
          Recipe recipe = Recipe(_title, _numberOfServings,
              creatorId: _uid,
              share: _share,
              ingredients: _ingredients,
              tags: []);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return EditRecipeDirectionsScreen(
                recipe: recipe,
                photo: _photo,
              );
            }),
          );
        }
      }
    }
  }

  Future _pickImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = img;
    });
  }

  BoxDecoration _buildBackground() {
    if (_photo != null) {
      return BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(_photo),
        ),
      );
    } else if (_photoUrl != null) {
      return BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: CachedNetworkImageProvider(_photoUrl)),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(oldRecipe == null ? "Create Recipe" : "Edit Recipe"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: _onSave,
            child: Text('Next'.toUpperCase()),
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
                        decoration: _buildBackground(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _title,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Title",
                      ),
                      onSaved: (value) => _title = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _numberOfServings.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Number of servings",
                      ),
                      onSaved: (value) => _numberOfServings = int.parse(value),
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  BlocBuilder<FoodBloc, FoodState>(
                    builder: (context, state) {
                      if (state is FoodLoaded) {
                        if (_ingredients.isEmpty) {
                          return _buildEmptyListCard();
                        } else {
                          return _buildListCard(state.foods);
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyListCard() {
    return Card(
      elevation: 0,
      borderOnForeground: true,
      margin: EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Tap '),
                Icon(Icons.add_circle),
                Text(' to add foods'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListCard(final List<Food> foods) {
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
              icon: Icon(Icons.add_circle),
              onPressed: _onAddButtonPressed,
              color: Colors.black,
            ),
          ),
          Divider(),
          ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, int index) {
              final ingredient = _ingredients[index];
              try {
                final food =
                    foods.firstWhere((food) => food.id == ingredient.foodId);
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
                        _ingredients.removeAt(index);
                      });
                    },
                  ),
                );
              } catch (err) {
                return Container();
              }
            },
            itemCount: _ingredients.length,
          )
        ],
      ),
    );
  }

  Future<void> _onAddButtonPressed() async {
    Navigator.pushNamed(context, FoodSearchScreen.routeName,
            arguments: FoodSearchArgument(action: FoodAction.ADD_TO_RECIPE))
        .then((result) {
      if (result is PopWithResults) {
        if (result.toPage == routeName) {
          final ingredient = Ingredient(
            result.results['foodId'] as String,
            result.results['quantity'] as String,
          );
          _ingredients.add(ingredient);
        }
      }
    });
  }
}
