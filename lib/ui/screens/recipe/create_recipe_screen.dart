import 'dart:io';

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

  @override
  State<StatefulWidget> createState() {
    return CreateRecipeScreenState();
  }
}

class CreateRecipeScreenState extends State<CreateRecipeScreen> {
  static final String routeName = '/createRecipe';
  String _title;
  int _numberOfServings;
  File _photo;
  String _photoUrl;
  String _uid;
  bool _share;
  List<Ingredient> _ingredients;
  final _formKey = GlobalKey<FormState>();
  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _ingredients = List<Ingredient>();
  }

  void _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final authState = _authBloc.state;
      if (authState is Authenticated) {
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

  Future _pickImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Create Recipe"),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  final ingredient = _ingredients[index];
                                  try {
                                    final food = state.foods.firstWhere(
                                        (food) => food.id == ingredient.foodId);
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
                                  } catch (StateError) {
                                    return Container();
                                  }
                                },
                                itemCount: _ingredients.length,
                              )
                            ],
                          ),
                        );
                      }
                    }
                    return Container();
                  },
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
