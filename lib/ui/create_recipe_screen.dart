import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_state.dart';
import 'package:calories/models/models.dart';
import 'package:calories/pop_with_result.dart';
import 'package:calories/ui/edit_recipe_directions_screen.dart';
import 'package:calories/ui/food_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  String _photoUrl;
  List<Ingredient> _ingredients;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _ingredients = List<Ingredient>();
  }

  void _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Recipe recipe = Recipe(_title,_numberOfServings, ingredients: _ingredients, tags: []);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) {
          return EditRecipeDirectionsScreen(recipe: recipe,);
        }),
      );
    }
  }

  Future<void> _onAddButtonPressed() async {
    Navigator.pushNamed(context, FoodSearchScreen.routeName,
            arguments: FoodSearchArgument(
                action: FoodSearchAction.SEARCH_FOR_INGREDIENT))
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Create new recipe"),
        actions: <Widget>[
          FlatButton(
            onPressed: _onSave,
            child: Text("NEXT"),
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
                      decoration: InputDecoration(labelText: "Title"),
                      onSaved: (value) => _title = value,
                      validator: (value) {
                        if (value.isEmpty) return "This field is required";
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: "Number of servings"),
                      onSaved: (value) => _numberOfServings = int.parse(value),
                      validator: (value) {
                        if (value.isEmpty) return "This field is required";
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
                if (state is FoodLoaded) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, int index) {
                      final ingredient = _ingredients[index];
                      final food = state.foods
                          .where((food) => food.id == ingredient.foodId)
                          .first;
                      return ListTile(
                        title: Text(food.name),
                        subtitle: Text(ingredient.quantity),
                      );
                    },
                    itemCount: _ingredients.length,
                  );
                }
                return null;
              }),
              RaisedButton(
                onPressed: _onAddButtonPressed,
                child: Text("Add"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
