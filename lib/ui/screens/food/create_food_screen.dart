import 'package:calories/models/models.dart';
import 'package:calories/ui/screens/food/nutrition_info_screen.dart';
import 'package:flutter/material.dart';

class CreateFoodScreen extends StatefulWidget {
  static final String routeName = '/createFood';
  @override
  State<StatefulWidget> createState() => _CreateFoodScreenState();
}

class _CreateFoodScreenState extends State<CreateFoodScreen> {
  static final String routeName = '/createFood';
  String _name;
  String _brand;
  String _photoUrl;
  String _unit;
  String _quantity;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Food food = Food(_name, brand: _brand, servings: Serving(_unit, _quantity), tags: []);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) {
          return NutritionInfoScreen(food: food);
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Create new food"),
        actions: <Widget>[
          FlatButton(
            onPressed: _onSave,
            child: Text("Save"),
          )
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Food name",
                ),
                onSaved: (value) => _name = value,
                validator: (value) {
                  if (value.isEmpty) return "Not be empty";
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Brand name",
                ),
                onSaved: (value) => _brand = value,
                validator: (value) {
                  if (value.isEmpty) return "Not be empty";
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Quantity",
                ),
                onSaved: (value) => _quantity = value,
                validator: (value) {
                  if (value.isEmpty) return "Not be empty";
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Unit",
                ),
                onSaved: (value) => _unit = value,
                validator: (value) {
                  if (value.isEmpty) return "Not be empty";
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
