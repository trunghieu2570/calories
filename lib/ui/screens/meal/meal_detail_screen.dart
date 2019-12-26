import 'package:cached_network_image/cached_network_image.dart';
import 'package:calories/blocs/auth/bloc.dart';
import 'package:calories/blocs/favorite_meals/bloc.dart';
import 'package:calories/blocs/food/bloc.dart';
import 'package:calories/blocs/meal/bloc.dart';
import 'package:calories/blocs/recipe/bloc.dart';
import 'package:calories/models/models.dart';
import 'package:calories/pop_with_result.dart';
import 'package:calories/ui/screens/meal/create_meal_screen.dart';
import 'package:calories/ui/widgets/meal_item_card_widget.dart';
import 'package:calories/ui/widgets/nutrition_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flushbar/flushbar.dart';

enum MealAction { ADD_TO_DIARY, NO_ACTION }

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
  MealAction _action;
  AuthBloc _authBloc;
  String _uid;

  @override
  void initState() {
    super.initState();
    _favoriteMealsBloc = BlocProvider.of<FavoriteMealsBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final authState = _authBloc.state;
    if (authState is Authenticated) {
      _uid = authState.user.uid;
    } else
      _uid = null;
  }

  Widget _buildAlert(bool show) => Builder(
        builder: (context) {
          if (show) {
            return Container(
              color: Colors.yellow,
              padding: EdgeInsets.only(left: 10),
              height: 40,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.info_outline, color: Colors.black),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "This meal has been deleted by owner.",
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )),
            );
          } else {
            return Container();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final MealDetailArgument args = ModalRoute.of(context).settings.arguments;
    _meal = args.meal;
    _action = args.action;

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
              _meal.creatorId == _uid
                  ? IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      CreateMealScreen(meal: _meal)))
                          .then((editedMeal) {
                        if (editedMeal != null)
                          Navigator.pushReplacementNamed(
                              context, MealDetailScreen.routeName,
                              arguments: MealDetailArgument(
                                  action: _action, meal: editedMeal));
                      }),
                    )
                  : Container(),
              _meal.creatorId == _uid
                  ? IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: () => _showDeleteDialog().then(
                        (isAccept) async {
                          if (isAccept) {
                            await _delete();
                            Navigator.pop(context);
                            Flushbar(
                              animationDuration: Duration(milliseconds: 500),
                              duration: Duration(seconds: 2),
                              message: 'Deleted successfully',
                            )..show(context);
                          }
                        },
                      ),
                    )
                  : Container(),
            ],
            title: Text("Meal Details"),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _meal.photoUrl != null
                        ? CachedNetworkImageProvider(_meal.photoUrl,
                            errorListener: () => print("Load failed"))
                        : CachedNetworkImageProvider(
                            'https://picsum.photos/600/400'),
                    fit: BoxFit.cover,
                  ),
                ),
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
              child: Column(
            children: <Widget>[
              _buildAlert(_isDeleted()),
              BlocBuilder<FoodBloc, FoodState>(
                builder: (context, foodState) {
                  return BlocBuilder<RecipeBloc, RecipeState>(
                      builder: (context, recipeState) {
                    if (foodState is FoodLoaded &&
                        recipeState is RecipesLoaded) {
                      final foods = foodState.foods;
                      final recipes = recipeState.recipes;
                      return Column(
                        children: <Widget>[
                          NutritionCard(
                              nutritionInfo:
                                  _meal.getSummaryNutrition(foods, recipes)),
                          MealItemCard(
                              items: _meal.items,
                              foods: foods,
                              recipes: recipes),
                        ],
                      );
                    }
                    return Container();
                  });
                },
              ),
            ],
          )),
        ],
      ),
      floatingActionButton: !_isDeleted()
          ? FloatingActionButton.extended(
              onPressed: _onAddButtonPressed,
              label: Text('Add'.toUpperCase()),
              icon: Icon(Icons.add),
            )
          : null,
    );
  }

  bool _isDeleted() {
    return (_meal.creatorId == '') && (_meal.share == false);
  }

  Future<bool> _showDeleteDialog() async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext dContext) {
          return AlertDialog(
            title: Text('Confirm delete'),
            content: Text('Please confirm your delete action.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'.toUpperCase()),
                onPressed: () => Navigator.pop(dContext, false),
              ),
              FlatButton(
                child: Text('Delete'.toUpperCase()),
                onPressed: () {
                  Navigator.pop(dContext, true);
                },
              )
            ],
          );
        });
  }

  Future<void> _delete() async {
    BlocProvider.of<FavoriteMealsBloc>(context)
        .add(DeleteFavoriteMeal(_meal.id));
    Meal newMeal = _meal.copyWith(creatorId: '', share: false);
    BlocProvider.of<MealBloc>(context).add(UpdateMeal(newMeal));
  }

  Future<void> _onAddButtonPressed() async {
    switch (_action) {
      case MealAction.ADD_TO_DIARY:
        Navigator.pop(
            context,
            PopWithResults(
              fromPage: MealDetailScreen.routeName,
              toPage: "/",
              results: {'items': _meal.items},
            ));
        break;
      case MealAction.NO_ACTION:
        // TODO: Handle this case.
        break;
    }
  }
}
