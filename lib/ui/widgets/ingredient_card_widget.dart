import 'package:calories/models/models.dart';
import 'package:calories/util.dart';
import 'package:flutter/material.dart';

class IngredientCard extends StatelessWidget {
  final List<Food> foods;
  final List<Ingredient> ingredients;
  final num quantity;

  IngredientCard(
      {Key key,
      @required this.ingredients,
      @required this.foods,
      this.quantity = 1})
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
              var weight = 0.0;
              if (food.servings.quantity != null) {
                weight = double.tryParse(food.servings.quantity);
                if (weight == null) weight = 0.0;
              }
              return ListTile(
                title: Text(
                  '${multiStringAndNum(ingredient.quantity, quantity)} ${food.name}',
                ),
                subtitle: Text(
                    '${multiStringAndNum(food.servings.quantity, quantity)} ${food.servings.unit}'),
              );
            },
            itemCount: ingredients.length,
          )
        ],
      ),
    );
  }
}
