import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_state.dart';
import 'package:calories/models/models.dart';
import 'package:calories/pop_with_result.dart';
import 'package:calories/ui/screens/recipe/recipe_detail_screen.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeSearchArgument {
  final RecipeAction action;

  RecipeSearchArgument({this.action});
}

class RecipeSearchScreen extends StatefulWidget {
  static final String routeName = "/recipeSearch";

  @override
  State<StatefulWidget> createState() => new RecipeSearchScreenState();
}

class RecipeSearchScreenState extends State<RecipeSearchScreen> {
  static final String routeName = "/recipeSearch";
  RecipeAction _action;
  String _searchQuery;

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

  @override
  Widget build(BuildContext context) {
    final RecipeSearchArgument args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      _action = args.action;
    }
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            titleSpacing: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.grey[100],
            title: TextField(
              autofocus: true,
              style: TextStyle(fontSize: 18),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration.collapsed(
                hintStyle: TextStyle(fontSize: 18),
                hintText: 'What recipe do you need?',
              ),
            ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                  ),
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
                if (state is RecipesLoading) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text("Loading")),
                  );
                } else if (state is RecipesLoaded) {
                  final allRecipes = state.recipes;
                  List<Recipe> recipes;
                  if (_searchQuery == null || _searchQuery == '')
                    recipes = allRecipes;
                  else {
                    recipes = allRecipes
                        .where((e) => removeDiacritics(e.title.toLowerCase())
                            .contains(
                                removeDiacritics(_searchQuery.toLowerCase())))
                        .toList();
                  }
                  recipes.sort((r1, r2) =>
                      removeDiacritics(r1.title.toLowerCase())
                          .compareTo(removeDiacritics(r2.title.toLowerCase())));
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final recipe = recipes[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(recipe.title),
                              subtitle: Text(
                                  recipe.numberOfServings.toString() +
                                      " serving(s)"),
                              onTap: () => _onRecipeTapped(recipe),
                            ),
                            Divider(height: 1),
                          ],
                        );
                      },
                      childCount: recipes.length,
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: Center(child: Text("Cannot load recipes")),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRecipeTapped(Recipe recipe) async {
    if (_action == null || _action == RecipeAction.NO_ACTION) {
      Navigator.pushNamed(context, RecipeDetailScreen.routeName,
          arguments: RecipeDetailArgument(recipe: recipe));
    } else {
      Navigator.pushNamed(
        context,
        RecipeDetailScreen.routeName,
        arguments: RecipeDetailArgument(
          recipe: recipe,
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
