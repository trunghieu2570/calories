import 'package:calories/models/food_model.dart';
import 'package:flutter/material.dart';

class NutritionCard extends StatelessWidget {
  final NutritionInfo nutritionInfo;
  final String headerTrailing;

  NutritionCard(
      {Key key, @required this.nutritionInfo, this.headerTrailing = ''})
      : assert(nutritionInfo != null),
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
            trailing: Text(
              headerTrailing,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 18,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            title: Text(
              'Nutrition Infomation',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "OpenSans"),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Calories',
            ),
            trailing: Text(nutritionInfo.calories + " kcal"),
          ),
          ListTile(
            title: Text(
              'Protein',
            ),
            trailing: Text(nutritionInfo.protein + " mg"),
          ),
          ListTile(
            title: Text(
              'Lipit',
            ),
            trailing: Text(nutritionInfo.fats + " mg"),
          ),
          ListTile(
            title: Text(
              'Saturated Fats',
            ),
            trailing: Text(nutritionInfo.saturatedFats + " mg"),
          ),
          ListTile(
            title: Text(
              'Carbohydrates',
            ),
            trailing: Text(nutritionInfo.carbohydrates + " mg"),
          ),
          ListTile(
            title: Text(
              'Sugars',
            ),
            trailing: Text(nutritionInfo.sugars + " mg"),
          ),
          ListTile(
            title: Text(
              'Sodium',
            ),
            trailing: Text(nutritionInfo.sodium + " mg"),
          ),
          ListTile(
            title: Text(
              'Fibers',
            ),
            trailing: Text(nutritionInfo.fiber + " mg"),
          ),
          ListTile(
            title: Text(
              'Cholesterol',
            ),
            trailing: Text(nutritionInfo.saturatedFats + " ml"),
          ),
        ],
      ),
    );
  }
}
