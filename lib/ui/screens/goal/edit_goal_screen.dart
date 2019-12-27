import 'package:calories/blocs/goals/goals_bloc.dart';
import 'package:calories/blocs/goals/goals_event.dart';
import 'package:calories/blocs/goals/goals_state.dart';
import 'package:calories/models/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditGoalScreen extends StatefulWidget {
  static final String routeName = '/editGoal';
  final DateTime startDate;
  EditGoalScreen({this.startDate});
  @override
  _EditGoalScreenState createState() => _EditGoalScreenState(startDate);
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  DateTime _startDate;
  final _formKey = GlobalKey<FormState>();
  String _name;
  bool _beginOnTomorow = true;
  Map<String, GoalCardItem> _goalItems;
  GoalBloc _goalBloc;

  _EditGoalScreenState(DateTime startDate)
      : _startDate = startDate ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );

  @override
  void initState() {
    super.initState();
    _goalBloc = BlocProvider.of<GoalBloc>(context);
    _goalItems = Map<String, GoalCardItem>();
    _goalItems[GoalItemType.CALORIES] = new GoalCardItem();
    _goalItems[GoalItemType.WATER] = new GoalCardItem();
    _goalItems[GoalItemType.CARBOHYDRATE] = new GoalCardItem();
    _goalItems[GoalItemType.PROTEIN] = new GoalCardItem();
    _goalItems[GoalItemType.LIPID] = new GoalCardItem();
    final goalsState = _goalBloc.state;
    if (goalsState is GoalsLoaded) {
      final beforeGoals = goalsState.goals
          .where((g) =>
              g.startDate.isBefore(_startDate) ||
              g.startDate.isAtSameMomentAs(_startDate))
          .toList();
      beforeGoals.sort();
      try {
        final goal = beforeGoals.last;
        _name = goal.name;
        goal.items.forEach((f) {
          final goalItem = _goalItems[f.type];
          goalItem.enable = true;
          if (f.max != null) {
            goalItem.enableMax = true;
            goalItem.maxEditController.text = f.max;
          }
          if (f.min != null) {
            goalItem.enableMin = true;
            goalItem.minEditController.text = f.min;
          }
        });
      } catch (err) {
        print(err);
      }
    }
  }

  void _save() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final List<GoalItem> items = new List<GoalItem>();
      _goalItems.forEach((type, item) {
        if (item.enable) {
          items.add(GoalItem(
              type,
              item.enableMin ? item.minEditController.text : null,
              item.enableMax ? item.maxEditController.text : null));
        }
      });
      Goal oldGoal;
      final goalsState = _goalBloc.state;
      if (goalsState is GoalsLoaded) {
        try {
          oldGoal =
              goalsState.goals.firstWhere((t) => t.startDate == _startDate);
        } catch (err) {
          print(err);
        }
      }
      if (oldGoal == null) {
        Goal newGoal = Goal(name: _name, startDate: _startDate, items: items);
        _goalBloc.add(AddGoal(newGoal));
      } else {
        Goal newGoal =
            oldGoal.copyWith(items: items, name: _name, startDate: _startDate);
        _goalBloc.add(UpdateGoal(newGoal));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Edit Your Goal"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: _save,
            child: Text("Save".toUpperCase()),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    initialValue: _name,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                      labelText: "Name",
                    ),
                    onSaved: (value) => _name = value,
                    validator: (value) {
                      if (value.isEmpty) return "Not be empty";
                      return null;
                    },
                  ),
                ),
                /* Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListTile(
                    title: Text('Begin on tomorrow'),
                    trailing: Switch(
                      onChanged: (v) {
                        setState(() {
                          _beginOnTomorow = v;
                        });
                      },
                      value: _beginOnTomorow,
                    ),
                  ),
                ), */
                _buildItemCard(
                    item: _goalItems[GoalItemType.CALORIES],
                    name: 'Calories',
                    unit: 'kcal'),
                _buildItemCard(
                    item: _goalItems[GoalItemType.WATER],
                    name: 'Water',
                    unit: 'ml'),
                _buildItemCard(
                    item: _goalItems[GoalItemType.CARBOHYDRATE],
                    name: 'Carbohydrate',
                    unit: 'mg'),
                _buildItemCard(
                    item: _goalItems[GoalItemType.PROTEIN],
                    name: 'Protein',
                    unit: 'mg'),
                _buildItemCard(
                    item: _goalItems[GoalItemType.LIPID],
                    name: 'Fats',
                    unit: 'mg'),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard({GoalCardItem item, String name, String unit}) {
    return Card(
      elevation: 0,
      borderOnForeground: true,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            trailing: Checkbox(
              value: item.enable,
              onChanged: (v) {
                setState(() {
                  item.enable = v;
                });
              },
            ),
            title: Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "OpenSans"),
            ),
          ),
          Divider(),
          ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              ListTile(
                leading: Checkbox(
                  value: item.enableMin,
                  onChanged: (v) {
                    setState(() {
                      item.enableMin = v;
                    });
                  },
                ),
                title: TextFormField(
                  enabled: item.enableMin,
                  controller: item.minEditController,
                  keyboardType: TextInputType.numberWithOptions(signed: false),
                  decoration: InputDecoration(
                    suffixText: unit,
                    fillColor: Colors.grey[200],
                    filled: true,
                    labelText: "Greater than or equal",
                  ),
                  validator: (value) {
                    if (value.isEmpty) return "Not be empty";
                    return null;
                  },
                ),
              ),
              ListTile(
                leading: Checkbox(
                  value: item.enableMax,
                  onChanged: (v) {
                    setState(() {
                      item.enableMax = v;
                    });
                  },
                ),
                title: TextFormField(
                  enabled: item.enableMax,
                  controller: item.maxEditController,
                  keyboardType: TextInputType.numberWithOptions(signed: false),
                  decoration: InputDecoration(
                    suffixText: unit,
                    fillColor: Colors.grey[200],
                    filled: true,
                    labelText: "Less than or equal",
                  ),
                  validator: (value) {
                    if (value.isEmpty) return "Not be empty";
                    return null;
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class GoalCardItem {
  bool _enable;

  bool get enable => _enable;

  set enable(bool enable) {
    _enable = enable;
    if (!_enable) {
      _enableMax = false;
      _enableMin = false;
    }
  }

  bool _enableMax;

  bool get enableMax => _enableMax;

  set enableMax(bool enableMax) {
    _enableMax = enableMax;
    if (!_enableMax && !_enableMin) {
      _enable = false;
    }
    if (_enableMax) {
      _enable = true;
    }
  }

  bool _enableMin;

  bool get enableMin => _enableMin;

  set enableMin(bool enableMin) {
    _enableMin = enableMin;
    if (!_enableMax && !_enableMin) {
      _enable = false;
    }
    if (_enableMin) {
      _enable = true;
    }
  }

  TextEditingController maxEditController;
  TextEditingController minEditController;

  GoalCardItem()
      : _enable = false,
        _enableMax = false,
        _enableMin = false,
        maxEditController = TextEditingController(text: '0'),
        minEditController = TextEditingController(text: '0');
}
