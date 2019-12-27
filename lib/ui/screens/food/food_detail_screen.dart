import 'package:cached_network_image/cached_network_image.dart';
import 'package:calories/blocs/auth/bloc.dart';
import 'package:calories/blocs/favorite_foods/bloc.dart';
import 'package:calories/blocs/food/bloc.dart';
import 'package:calories/models/models.dart';
import 'package:calories/pop_with_result.dart';
import 'package:calories/ui/screens/food/create_edit_food_screen.dart';
import 'package:calories/ui/screens/meal/create_meal_screen.dart';
import 'package:calories/ui/screens/recipe/create_recipe_screen.dart';
import 'package:calories/ui/widgets/nutrition_card_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum FoodAction {
  ADD_TO_MEAL,
  ADD_TO_RECIPE,
  ADD_TO_DIARY,
  NO_ACTION,
}

class FoodDetailArgument {
  final Food food;
  final FoodAction action;

  FoodDetailArgument({@required this.food, this.action}) : assert(food != null);
}

class FoodDetailScreen extends StatefulWidget {
  static final String routeName = '/foodDetail';

  @override
  State<StatefulWidget> createState() => new FoodDetailScreenState();
}

class FoodDetailScreenState extends State<FoodDetailScreen> {
  Food _food;
  FavoriteFoodsBloc _favoriteFoodsBloc;
  FoodAction _action;
  AuthBloc _authBloc;
  String _uid;
  TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
    _favoriteFoodsBloc = BlocProvider.of<FavoriteFoodsBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final authState = _authBloc.state;
    if (authState is Authenticated) {
      _uid = authState.user.uid;
    } else
      _uid = null;
  }

  Widget _buildAlert(bool show) =>
      Builder(
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
    final FoodDetailArgument args = ModalRoute
        .of(context)
        .settings
        .arguments;
    _food = args.food;
    _action = args.action;
    var weight = 0.0;
    var quantity = 0.0;
    if (_food.servings.quantity != null) {
      weight = double.tryParse(_food.servings.quantity);
      if (weight == null) weight = 0.0;
    }
    if (_quantityController.text != null) {
      quantity = double.tryParse(_quantityController.text);
      if (quantity == null) {
        quantity = 0.0;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            automaticallyImplyLeading: true,
            actions: <Widget>[
              BlocBuilder<FavoriteFoodsBloc, FavoriteFoodsState>(
                  builder: (context, state) {
                    if (state is FavoriteFoodsLoaded) {
                      final _isFavorite = state.foodIds.contains(_food.id);
                      return IconButton(
                        icon: _isFavorite
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        onPressed: () {
                          if (_isFavorite) {
                            Scaffold.of(context).removeCurrentSnackBar();
                            _favoriteFoodsBloc.add(DeleteFavoriteFood(
                                _food.id));
                            final snackBar =
                            SnackBar(content: Text('Remove favorite'));
                            Scaffold.of(context).showSnackBar(snackBar);
                          } else {
                            Scaffold.of(context).removeCurrentSnackBar();
                            _favoriteFoodsBloc.add(AddFavoriteFood(_food.id));

                            final snackBar =
                            SnackBar(content: Text('Add favorite'));
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        },
                      );
                    }

                    return Container();
                  }),
              _food.creatorId == _uid
                  ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: () =>
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateFoodScreen(food: _food),
                        )).then((editedFood) {
                      if (editedFood != null) {
                        Navigator.pushReplacementNamed(
                            context, FoodDetailScreen.routeName,
                            arguments: FoodDetailArgument(
                                action: _action, food: editedFood));
                      }
                    }),
              )
                  : Container(),
              _food.creatorId == _uid
                  ? IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () =>
                    _showDeleteDialog().then((isAccept) async {
                      if (isAccept) {
                        await _delete();
                        Navigator.pop(context);
                        Flushbar(
                          animationDuration: Duration(milliseconds: 500),
                          duration: Duration(seconds: 2),
                          message: 'Deleted successfully',
                        )
                          ..show(context);
                      }
                    }),
              )
                  : Container(),
            ],
            title: Text("Food details"),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _food.photoUrl != null
                        ? CachedNetworkImageProvider(_food.photoUrl)
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
                            _food.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            _food.brand,
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
                  new BoxDecoration(color: Theme
                      .of(context)
                      .cardColor),
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
                                            var num = double.tryParse(
                                                _quantityController.text);
                                            if (num == null) num = 0.0;
                                            num = num.round().toDouble() + 1;
                                            _quantityController.text =
                                                num.round().toString();
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
                NutritionCard(
                  nutritionInfo: _quantityController.text != null
                      ? _food.nutritionInfo * quantity
                      : NutritionInfo.empty(),
                  headerTrailing: '${quantity * weight} ${_food.servings.unit}',
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: (!_isDeleted() && _action != null)
          ? FloatingActionButton.extended(
        onPressed: _onAddButtonPressed,
        label: Text('Add'.toUpperCase()),
        icon: Icon(Icons.add),
      ): null,
    );
  }

  bool _isDeleted() {
    return (_food.creatorId == '') && (_food.share == false);
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
    BlocProvider.of<FavoriteFoodsBloc>(context)
        .add(DeleteFavoriteFood(_food.id));
    Food newFood = _food.copyWith(creatorId: '', share: false);
    BlocProvider.of<FoodBloc>(context).add(UpdateFood(newFood));
  }

  Future<void> _onAddButtonPressed() async {
    switch (_action) {
      case FoodAction.ADD_TO_RECIPE:
        Navigator.pop(
            context,
            PopWithResults(
                fromPage: FoodDetailScreen.routeName,
                toPage: CreateRecipeScreen.routeName,
                results: {
                  'foodId': '${_food.id}',
                  'quantity': '${_quantityController.text}'
                }));
        break;
      case FoodAction.ADD_TO_MEAL:
        Navigator.pop(
            context,
            PopWithResults(
                fromPage: FoodDetailScreen.routeName,
                toPage: CreateMealScreen.routeName,
                results: {
                  'foodId': '${_food.id}',
                  'quantity': '${_quantityController.text}'
                }));
        break;
      case FoodAction.ADD_TO_DIARY:
        Navigator.pop(
            context,
            PopWithResults(
                fromPage: FoodDetailScreen.routeName,
                toPage: "/",
                results: {
                  'foodId': '${_food.id}',
                  'quantity': '${_quantityController.text}'
                }));
        break;
      case FoodAction.NO_ACTION:
        break;
    }
  }
}
