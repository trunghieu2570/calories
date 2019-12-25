import 'package:calories/models/models.dart';
import 'package:flutter/material.dart';

class DailyMealItemCard extends StatelessWidget {
  final List<Recipe> recipes;
  final List<Food> foods;
  final List<MealItem> items;
  final String title;
  final Function() onAddButtonPressed;
  final Function(String id) onRemoveButtonPressed;
  final GlobalKey _menuKey = GlobalKey();

  DailyMealItemCard(
      {Key key,
      this.title = 'Meal items',
      this.onAddButtonPressed,
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
            title: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "OpenSans"),
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
              if (item.type == MealItemType.FOOD) {
                try {
                  final food =
                      foods.firstWhere((food) => food.id == item.itemId);
                  return ListTile(
                    onLongPress: () => onRemoveButtonPressed(item.itemId),
                    title: Text(food.name),
                    subtitle: Text(food.brand),
                  );
                } catch (err) {
                  return Container();
                }
              } else if (item.type == MealItemType.RECIPE) {
                try {
                  final recipe = recipes.firstWhere((e) => e.id == item.itemId);
                  return ListTile(
                    onLongPress: () => onRemoveButtonPressed(item.itemId),
                    title: Text(recipe.title),
                    subtitle: Text(
                        recipe.numberOfServings.toString() + " serving(s)"),
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
