import 'package:calories/models/models.dart';
import 'package:flutter/material.dart';

class IngredientCard extends StatelessWidget {
  final List<Food> foods;
  final List<Ingredient> ingredients;

  IngredientCard({Key key, @required this.ingredients, @required this.foods})
      : assert(ingredients != null),
        assert(foods != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      borderOnForeground: true,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            child: Text(
              'Ingredients',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "OpenSans"),
            ),
          ),
          Divider(),
          ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, int index) {
              final ingredient = ingredients[index];
              final food =
                  foods.where((food) => food.id == ingredient.foodId).first;
              return ListTile(
                title: Text(
                  food.name,
                ),
                subtitle: Text(ingredient.quantity + " " + food.servings.unit),
              );
            },
            itemCount: ingredients.length,
          )
        ],
      ),
    );
  }
}
