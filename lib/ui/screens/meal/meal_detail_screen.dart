import 'package:calories/blocs/favorite_meals/bloc.dart';
import 'package:calories/blocs/food/bloc.dart';
import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_state.dart';
import 'package:calories/models/models.dart';
import 'package:calories/ui/widgets/meal_item_card_widget.dart';
import 'package:calories/ui/widgets/nutrition_card_widget.dart';
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
    final MealDetailArgument args = ModalRoute.of(context).settings.arguments;
    _meal = args.meal;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
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
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => {},
              ),
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () => {},
              ),
            ],
            title: Text("Meal details"),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage('https://picsum.photos/600/400'),
                  fit: BoxFit.cover,
                )),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _meal.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w500),
                          ),
                          /*Text(
                            _recipe.numberOfServings.toString() + " servings",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),*/
                        ],
                      )),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<FoodBloc, FoodState>(
              builder: (context, foodState) {
                return BlocBuilder<RecipeBloc, RecipeState>(
                    builder: (context, recipeState) {
                  if (foodState is FoodLoaded && recipeState is RecipesLoaded) {
                    final foods = foodState.foods;
                    final recipes = recipeState.recipes;
                    return Column(
                      children: <Widget>[
                        NutritionCard(
                            nutritionInfo:
                                _meal.getSummaryNutrition(foods, recipes)),
                        MealItemCard(
                            items: _meal.items, foods: foods, recipes: recipes),
                      ],
                    );
                  }
                  return Container();
                });
              },
            ),
          ),
        ],
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
