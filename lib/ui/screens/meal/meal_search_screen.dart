import 'package:calories/blocs/meal/bloc.dart';
import 'package:calories/models/models.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'meal_detail_screen.dart';

enum MealSearchAction { SEARCH_FOR_DIARY }

class MealSearchArgument {
  final MealSearchAction mealSearchAction;

  MealSearchArgument({this.mealSearchAction});
}

class MealSearchScreen extends StatefulWidget {
  static final String routeName = "/mealSearch";
  @override
  _MealSearchScreenState createState() => _MealSearchScreenState();
}

class _MealSearchScreenState extends State<MealSearchScreen> {
  static final String routeName = "/mealSearch";
  MealSearchAction _action;
  String _searchQuery;

  void _onFilterPress(BuildContext pcontext) {
    showDialog(
        context: pcontext,
        builder: (BuildContext context) {
          return _filterDialog();
        });
  }

  Widget _filterDialog() {
    return AlertDialog(
      contentPadding: EdgeInsets.all(15),
      titleTextStyle: TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 4,
          children: List<Widget>.generate(
            50,
            (int index) {
              return ChoiceChip(
                pressElevation: 0.0,
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey[100],
                label: Text("item $index"),
                selected: false,
              );
            },
          ).toList(),
        ),
      ),
      title: Text('Chọn các bộ lọc'),
      actions: <Widget>[
        FlatButton(
          child: Text('Đóng'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            titleSpacing: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.grey[100],
            title: TextField(
              autofocus: true,
              style: TextStyle(fontSize: 18),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration.collapsed(
                hintStyle: TextStyle(fontSize: 18),
                hintText: 'What meal do you need?',
              ),
            ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                  ),
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              BlocBuilder<MealBloc, MealState>(builder: (context, state) {
                if (state is MealsLoading) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text("Loading")),
                  );
                } else if (state is MealsLoaded) {
                  final allMeals = state.meals;
                  List<Meal> meals;
                  if (_searchQuery == null || _searchQuery == '')
                    meals = allMeals;
                  else {
                    meals = allMeals
                        .where((e) => removeDiacritics(e.name.toLowerCase())
                            .contains(
                                removeDiacritics(_searchQuery.toLowerCase())))
                        .toList();
                  }
                  meals.sort((m1, m2) => removeDiacritics(m1.name.toLowerCase())
                      .compareTo(removeDiacritics(m2.name.toLowerCase())));
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final meal = meals[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(meal.name),
                              onTap: () => _onMealTapped(meal),
                            ),
                            Divider(height: 1),
                          ],
                        );
                      },
                      childCount: meals.length,
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: Center(child: Text("Cannot load meals")),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onMealTapped(Meal meal) async {
    Navigator.pushNamed(context, MealDetailScreen.routeName,
        arguments: MealDetailArgument(meal: meal));
  }
}
