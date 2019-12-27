import 'package:cached_network_image/cached_network_image.dart';
import 'package:calories/blocs/auth/bloc.dart';
import 'package:calories/blocs/favorite_recipes/favorite_recipes_bloc.dart';
import 'package:calories/blocs/favorite_recipes/favorite_recipes_event.dart';
import 'package:calories/blocs/favorite_recipes/favorite_recipes_state.dart';
import 'package:calories/blocs/food/bloc.dart';
import 'package:calories/blocs/recipe/bloc.dart';
import 'package:calories/blocs/recipe/recipe_event.dart';
import 'package:calories/models/models.dart';
import 'package:calories/pop_with_result.dart';
import 'package:calories/ui/screens/meal/create_meal_screen.dart';
import 'package:calories/ui/screens/recipe/create_recipe_screen.dart';
import 'package:calories/ui/widgets/directions_card_widget.dart';
import 'package:calories/ui/widgets/ingredient_card_widget.dart';
import 'package:calories/ui/widgets/nutrition_card_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum RecipeAction {
  ADD_TO_MEAL,
  ADD_TO_DIARY,
  NO_ACTION,
}

class RecipeDetailArgument {
  final Recipe recipe;
  final RecipeAction action;

  RecipeDetailArgument({@required this.recipe, this.action})
      : assert(recipe != null);
}

class RecipeDetailScreen extends StatefulWidget {
  static final String routeName = '/recipeDetail';

  @override
  State<StatefulWidget> createState() => new _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Recipe _recipe;

  FavoriteRecipesBloc _favoriteRecipesBloc;
  RecipeAction _action;
  TextEditingController _quantityController;
  AuthBloc _authBloc;
  String _uid;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
    _favoriteRecipesBloc = BlocProvider.of<FavoriteRecipesBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final authState = _authBloc.state;
    if (authState is Authenticated) {
      _uid = authState.user.uid;
    } else
      _uid = null;
  }

  @override
  Widget build(BuildContext context) {
    final RecipeDetailArgument args = ModalRoute.of(context).settings.arguments;
    _recipe = args.recipe;
    _action = args.action;
    num quantity = 0;
    if (_quantityController.text != null) {
      quantity = num.tryParse(_quantityController.text);
      if (quantity == null) {
        quantity = 0;
      }
    }
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            automaticallyImplyLeading: true,
            actions: <Widget>[
              BlocBuilder<FavoriteRecipesBloc, FavoriteRecipesState>(
                  builder: (context, state) {
                if (state is FavoriteRecipesLoaded) {
                  final _isFavorite = state.recipeIds.contains(_recipe.id);
                  return IconButton(
                    icon: _isFavorite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    onPressed: () {
                      if (_isFavorite) {
                        Scaffold.of(context).removeCurrentSnackBar();
                        _favoriteRecipesBloc
                            .add(DeleteFavoriteRecipe(_recipe.id));
                        final snackBar = SnackBar(
                          content: Text('Đã loại bỏ yêu thích'),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      } else {
                        Scaffold.of(context).removeCurrentSnackBar();
                        _favoriteRecipesBloc.add(AddFavoriteRecipe(_recipe.id));
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
              _recipe.creatorId == _uid
                  ? IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateRecipeScreen(recipe: _recipe),
                        ),
                      ).then(
                        (editedRecipe) {
                          if (editedRecipe != null)
                            Navigator.pushReplacementNamed(
                              context,
                              RecipeDetailScreen.routeName,
                              arguments: RecipeDetailArgument(
                                  action: _action, recipe: editedRecipe),
                            );
                        },
                      ),
                    )
                  : Container(),
              _recipe.creatorId == _uid
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
            title: Text("Recipe Details"),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _recipe.photoUrl != null
                        ? CachedNetworkImageProvider(_recipe.photoUrl)
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
                            _recipe.title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            _recipe.numberOfServings.toString() + " servings",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
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
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration:
                new BoxDecoration(color: Theme.of(context).cardColor),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Divider(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            child: Icon(
                              FontAwesomeIcons.calculator,
                              color: Colors.grey[600],
                            ),
                            padding: EdgeInsets.all(10)),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                child: TextFormField(
                                  controller: _quantityController,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  keyboardType:
                                  TextInputType.numberWithOptions(
                                      decimal: true),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.keyboard_arrow_up),
                                      onPressed: () {
                                        setState(() {
                                          var val = double.tryParse(
                                              _quantityController.text);
                                          if (val == null) val = 0.0;
                                          val = val.round().toDouble() + 1;
                                          _quantityController.text =
                                              val.round().toString();
                                        });
                                      },
                                    ),
                                    prefixIcon: IconButton(
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      onPressed: () {
                                        setState(() {
                                          var num = double.tryParse(
                                              _quantityController.text);
                                          if (num == null) num = 0.0;
                                          num = num.round().toDouble() - 1;
                                          if (num < 0) num = 0;
                                          _quantityController.text =
                                              num.round().toString();
                                        });
                                      },
                                    ),
                                    hintText: 'QT',
                                  ),
                                ),
                                width: 150,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
                if (state is FoodLoaded) {
                  final foods = state.foods;
                  return Column(
                    children: <Widget>[
                      NutritionCard(
                          nutritionInfo: _recipe.getSummaryNutrition(foods) * quantity),
                      IngredientCard(
                          ingredients: _recipe.ingredients, foods: foods, quantity: quantity,),
                      DirectionsCard(directions: _recipe.directions),
                    ],
                  );
                }
                return Text("No connection");
              }),
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
                          "This recipe has been deleted by owner.",
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

  bool _isDeleted() {
    return (_recipe.creatorId == '') && (_recipe.share == false);
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
    BlocProvider.of<FavoriteRecipesBloc>(context)
        .add(DeleteFavoriteRecipe(_recipe.id));
    Recipe newMeal = _recipe.copyWith(creatorId: '', share: false);
    BlocProvider.of<RecipeBloc>(context).add(UpdateRecipe(newMeal));
  }

  Future<void> _onAddButtonPressed() async {
    switch (_action) {
      case RecipeAction.ADD_TO_MEAL:
        Navigator.pop(
            context,
            PopWithResults(
                fromPage: RecipeDetailScreen.routeName,
                toPage: CreateMealScreen.routeName,
                results: {
                  'recipeId': '${_recipe.id}',
                  'quantity': '${_quantityController.text}'
                }));
        break;
      case RecipeAction.ADD_TO_DIARY:
        Navigator.pop(
            context,
            PopWithResults(
                fromPage: RecipeDetailScreen.routeName,
                toPage: "/",
                results: {
                  'recipeId': '${_recipe.id}',
                  'quantity': '${_quantityController.text}'
                }));
        break;
      case RecipeAction.NO_ACTION:
        // TODO: Handle this case.
        break;
    }
  }
}
