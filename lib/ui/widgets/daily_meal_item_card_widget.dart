import 'package:calories/models/models.dart';
import 'package:calories/ui/screens/food/food_detail_screen.dart';
import 'package:calories/ui/screens/recipe/recipe_detail_screen.dart';
import 'package:calories/util.dart';
import 'package:flutter/material.dart';

class DailyMealItemCard extends StatelessWidget {
  final List<Recipe> recipes;
  final List<Food> foods;
  final List<MealItem> items;
  final String sumCalories;
  final String title;
  final Function() onAddButtonPressed;
  final Function(MealItem id) onRemoveButtonPressed;
  final GlobalKey _menuKey = GlobalKey();

  DailyMealItemCard(
      {Key key,
      this.title = 'Items',
      this.onAddButtonPressed,
      this.sumCalories,
      this.onRemoveButtonPressed,
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
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: "OpenSans"),
                ),
                SizedBox(width: 10),
                Text(
                  '•  $sumCalories kcal',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "OpenSans"),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.black,
              ),
              onPressed: onAddButtonPressed,
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
                    onLongPress: () => onRemoveButtonPressed(item),
                    onTap: () => Navigator.pushNamed(
                        context, FoodDetailScreen.routeName,
                        arguments: FoodDetailArgument(food: food)),
                    title: Text(food.name),
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
                    onLongPress: () => onRemoveButtonPressed(item),
                    title: Text(recipe.title),
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
                    onTap: () => Navigator.pushNamed(
                        context, RecipeDetailScreen.routeName,
                        arguments: RecipeDetailArgument(recipe: recipe)),
                  );
                } catch (err) {
                  return Container();
                }
              } else if (item.type == MealItemType.WATER) {
                return ListTile(
                  onLongPress: () => onRemoveButtonPressed(item),
                  title: Text('A Glass of Water'),
                  subtitle: Text('${item.quantity} ml'),
                );
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
