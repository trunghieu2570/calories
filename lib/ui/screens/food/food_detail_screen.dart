import 'package:calories/blocs/favorite_foods/bloc.dart';
import 'package:calories/models/models.dart';
import 'package:calories/pop_with_result.dart';
import 'package:calories/ui/screens/food/create_edit_food_screen.dart';
import 'package:calories/ui/screens/meal/create_meal_screen.dart';
import 'package:calories/ui/screens/recipe/create_recipe_screen.dart';
import 'package:calories/ui/widgets/nutrition_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  FoodAction _foodAction;
  TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCity = _dropDownMenuItems[0].value;
    _favoriteFoodsBloc = BlocProvider.of<FavoriteFoodsBloc>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _cities) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  List _cities = [
    "Cluj-Napoca",
    "Bucuresti",
    "Timisoara",
    "Brasov",
    "Constanta"
  ];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCity;

  @override
  Widget build(BuildContext context) {
    final FoodDetailArgument args = ModalRoute.of(context).settings.arguments;
    _food = args.food;
    _foodAction = args.action;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                        _favoriteFoodsBloc.add(DeleteFavoriteFood(_food.id));
                        final snackBar =
                            SnackBar(content: Text('Đã loại bỏ yêu thích'));
                        Scaffold.of(context).showSnackBar(snackBar);
                      } else {
                        Scaffold.of(context).removeCurrentSnackBar();
                        _favoriteFoodsBloc.add(AddFavoriteFood(_food.id));

                        final snackBar =
                            SnackBar(content: Text('Đã thêm vào yêu thích'));
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    },
                  );
                }

                return Container();
              }),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreateFoodScreen(food: _food))),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () => {},
              ),
            ],
            title: Text("Food details"),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _food.photoUrl != null
                        ? NetworkImage(_food.photoUrl)
                        : NetworkImage('https://picsum.photos/600/400'),
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
                Builder(
                  builder: (context) {
                    if (_food.creatorId == null || _food.creatorId == "") {
                      return Container(
                        color: Colors.yellow,
                        padding: EdgeInsets.only(left: 10),
                        height: 40,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Thực phẩm này đã bị xóa bởi người tạo ra nó",
                            style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                NutritionCard(
                  nutritionInfo: _food.nutritionInfo,
                  headerTrailing:
                      _food.servings.quantity + ' ' + _food.servings.unit,
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddButtonPressed,
        label: Text('Thêm vào'),
        icon: Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        decoration: new BoxDecoration(color: Theme.of(context).cardColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Divider(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  // width: 30,
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_up),
                    padding: EdgeInsets.all(0.0),
                    //padding: EdgeInsets.symmetric(horizontal: 1),
                    onPressed: () => {},
                  ),
                  //padding: EdgeInsets.symmetric(horizontal: 2.0),
                ),
                Container(
                  //padding: EdgeInsets.symmetric(horizontal: 8.0),
                  width: 60,
                  child: new TextField(
                    controller: _quantityController,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      //filled: true,
                      //fillColor: Colors.grey[100],
                      hintText: 'SL',
                    ),
                  ),
                ),
                Container(
                  //width: 30,
                  child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: () => {},
                  ),
                  //padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButton(
                      isExpanded: true,
                      hint: Text('Select'),
                      value: _currentCity,
                      items: _dropDownMenuItems,
                      onChanged: (str) => setState(() {
                        _currentCity = str;
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAddButtonPressed() async {
    switch (_foodAction) {
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
        break;
      case FoodAction.NO_ACTION:
        break;
    }
  }
}
