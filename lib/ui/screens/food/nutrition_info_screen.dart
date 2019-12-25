import 'dart:io';

import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_event.dart';
import 'package:calories/models/models.dart';
import 'package:calories/ui/screens/food/food_search_screen.dart';
import 'package:calories/ui/widgets/loading_stack_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NutritionInfoScreen extends StatefulWidget {
  final Food food;
  final File photo;

  NutritionInfoScreen({Key key, @required this.food, this.photo})
      : assert(food != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _NutritionInfoScreenState(food, photo);
}

class _NutritionInfoScreenState extends State<NutritionInfoScreen> {
  final Food food;
  final File photo;
  FoodBloc _foodBloc;
  final _formKey = GlobalKey<FormState>();

  static const double _padding = 5;

  _NutritionInfoScreenState(this.food, this.photo);

  String _calories;
  String _fats;
  String _carbohydrates;
  String _protein;
  String _saturatedFats;
  String _sodium;
  String _fiber;
  String _cholesterol;
  String _sugars;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _foodBloc = BlocProvider.of<FoodBloc>(context);
    if (food.nutritionInfo != null) {
      final nutrition = food.nutritionInfo;
      _calories = nutrition.calories;
      _fats = nutrition.fats;
      _carbohydrates = nutrition.carbohydrates;
      _protein = nutrition.protein;
      _saturatedFats = nutrition.saturatedFats;
      _sodium = nutrition.sodium;
      _fiber = nutrition.fiber;
      _cholesterol = nutrition.cholesterol;
      _sugars = nutrition.sugars;
    }
  }

  void _setLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<String> _uploadImage(File image) async {
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(image.hashCode.toString())
        .child("image.jpg");
    StorageUploadTask uploadTask = ref.putFile(image);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  void _onSave() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _setLoadingState(true);
      String photoUrl;
      if (photo != null) photoUrl = await _uploadImage(photo);
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
      Food newFood =
          food.copyWith(nutritionInfo: nutritionInfo, photoUrl: photoUrl);
      if (newFood.id != null) {
        _foodBloc.add(UpdateFood(newFood));
        Navigator.pop(
            context, newFood);
      } else {
        _foodBloc.add(AddFood(newFood));
        Navigator.popUntil(context, ModalRoute.withName("/"));
      }
      _setLoadingState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingStack(
      body: _buildBody(),
      state: _isLoading,
    );
  }

  Widget _buildBody() => Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Enter nutrition infomation"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: _onSave,
            child: Text("Save".toUpperCase()),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.grey[200],
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _calories,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: 'kcal',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Calories",
                      ),
                      onSaved: (value) => _calories = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _fats,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: 'mg',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Fats",
                      ),
                      onSaved: (value) => _fats = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _saturatedFats,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: 'mg',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Saturated Fats",
                      ),
                      onSaved: (value) => _saturatedFats = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _carbohydrates,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: 'mg',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Carbohydrates",
                      ),
                      onSaved: (value) => _carbohydrates = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  Container(height: _padding),
                  TextFormField(
                    initialValue: _protein,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixText: 'mg',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(15),
                      labelText: "Protein",
                    ),
                    onSaved: (value) => _protein = value,
                    validator: (value) {
                      if (value.isEmpty) return "Not be empty";
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _sodium,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: 'mg',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Sodium",
                      ),
                      onSaved: (value) => _sodium = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _sugars,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: 'mg',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Sugars",
                      ),
                      onSaved: (value) => _sugars = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _fiber,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: 'mg',
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Fiber",
                        contentPadding: EdgeInsets.all(15),
                      ),
                      onSaved: (value) => _fiber = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _cholesterol,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: 'ml',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Cholesterol",
                      ),
                      onSaved: (value) => _cholesterol = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
}
