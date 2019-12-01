import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_event.dart';
import 'package:calories/models/models.dart';
import 'package:calories/ui/food_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NutritionInfoScreen extends StatefulWidget {
  final Food food;

  NutritionInfoScreen({Key key, @required this.food})
      : assert(food != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => NutritionInfoScreenState(food: food);
}

class NutritionInfoScreenState extends State<NutritionInfoScreen> {
  final Food food;
  FoodBloc _foodBloc;
  final _formKey = GlobalKey<FormState>();

  NutritionInfoScreenState({@required this.food}) : assert(food != null);
  String _calories;
  String _fats;
  String _carbohydrates;
  String _protein;
  String _saturatedFats;
  String _sodium;
  String _fiber;
  String _cholesterol;
  String _sugars;

  @override
  void initState() {
    super.initState();
    _foodBloc = BlocProvider.of<FoodBloc>(context);
  }

  void _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      NutritionInfo nutritionInfo = NutritionInfo(
          carbohydrates: _carbohydrates,
          fats: _fats,
          protein: _protein,
          calories: _calories,
          cholesterol: _cholesterol,
          fiber: _fiber,
          sugars: _sugars,
          sodium: _sodium,
          saturatedFats: _saturatedFats);
      Food newFood = food.copyWith(nutritionInfo: nutritionInfo);
      _foodBloc.add(AddFood(newFood));
      Navigator.popUntil(context, ModalRoute.withName("/"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Food nutrition info"),
        actions: <Widget>[
          FlatButton(
            onPressed: _onSave,
            child: Text("Save"),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Calories",
                  ),
                  onSaved: (value) => _calories = value,
                  validator: (value) {
                    if (value.isEmpty) return "Not be empty";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Fats",
                  ),
                  onSaved: (value) => _fats = value,
                  validator: (value) {
                    if (value.isEmpty) return "Not be empty";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Saturated Fats",
                  ),
                  onSaved: (value) => _saturatedFats = value,
                  validator: (value) {
                    if (value.isEmpty) return "Not be empty";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Carbohydrates",
                  ),
                  onSaved: (value) => _carbohydrates = value,
                  validator: (value) {
                    if (value.isEmpty) return "Not be empty";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Protein",
                  ),
                  onSaved: (value) => _protein = value,
                  validator: (value) {
                    if (value.isEmpty) return "Not be empty";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Sodium",
                  ),
                  onSaved: (value) => _sodium = value,
                  validator: (value) {
                    if (value.isEmpty) return "Not be empty";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Sugars",
                  ),
                  onSaved: (value) => _sugars = value,
                  validator: (value) {
                    if (value.isEmpty) return "Not be empty";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Fiber",
                  ),
                  onSaved: (value) => _fiber = value,
                  validator: (value) {
                    if (value.isEmpty) return "Not be empty";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Cholesterol",
                  ),
                  onSaved: (value) => _cholesterol = value,
                  validator: (value) {
                    if (value.isEmpty) return "Not be empty";
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
