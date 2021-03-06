import 'package:calories/models/models.dart';
import 'package:calories/util.dart';
import 'package:flutter/material.dart';

class MealItemCard extends StatelessWidget {
  final List<Recipe> recipes;
  final List<Food> foods;
  final List<MealItem> items;
  final String title;

  MealItemCard(
      {Key key,
      this.title = 'Meal items',
      @required this.items,
      @required this.recipes,
      @required this.foods})
      : assert(items != null),
        assert(recipes != null),
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
              title,
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
              final item = items[index];
              var quantity = 0;
              if (item.quantity != null) {
                quantity = num.tryParse(item.quantity);
                if (quantity == null) quantity = 0;
              }
              if (item.type == MealItemType.FOOD) {

                try {
                  final food =
                      foods.firstWhere((food) => food.id == item.itemId);
                  return ListTile(
                    title: Text(
                      food.name,
                    ),
                    subtitle: Text(
                      '${item.quantity} • ${multiStringAndNum(food.servings.quantity, quantity)} ${food.servings.unit}',
                    ),
                    trailing: Text(
                      '${multiStringAndNum(food.nutritionInfo.calories, quantity)} kcal',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500),
                    ),
                  );
                } catch (err) {
                  return Container();
                }
              } else if (item.type == MealItemType.RECIPE) {
                try {
                  final recipe = recipes.firstWhere((e) => e.id == item.itemId);
                  return ListTile(
                    title: Text(
                      recipe.title,
                    ),
                    subtitle: Text(
                      '$quantity servings',
                    ),
                    trailing: Text(
                      '${multiStringAndNum(recipe.getSummaryNutrition(foods).calories, quantity)} kcal',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500),
                    ),
                  );
                } catch (err) {
                  return Container();
                }
              }
              return Container();
            },
            itemCount: items.length,
          )
        ],
      ),
    );
  }
}
