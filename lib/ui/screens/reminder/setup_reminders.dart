import 'package:calories/blocs/goals/goals_bloc.dart';
import 'package:calories/models/daily_meal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetRemindersScreen extends StatefulWidget {
  static final String routeName = '/setReminders';

  SetRemindersScreen();

  @override
  _SetRemindersScreenState createState() => _SetRemindersScreenState();
}

class _SetRemindersScreenState extends State<SetRemindersScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, ReminderCardItem> _goalItems;
  ReminderWaterCardItem _waterItem;
  GoalBloc _goalBloc;

  @override
  void initState() {
    super.initState();

    _goalBloc = BlocProvider.of<GoalBloc>(context);
    _goalItems = Map<String, ReminderCardItem>();
    _goalItems[DailyMealSection.BREAKFAST] = new ReminderCardItem();
    _goalItems[DailyMealSection.LUNCH] = new ReminderCardItem();
    _goalItems[DailyMealSection.DINNER] = new ReminderCardItem();
    _goalItems['water'] = new ReminderCardItem();
    _init();
  }

  Future<void> _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _goalItems.forEach((type, item) async {
      if (prefs.getInt('rmh$type') != null) {
        int h = prefs.getInt('rmh$type');
        int m = prefs.getInt('rmm$type');
        setState(() {
          item.time = TimeOfDay(hour: h, minute: m);
          item.enable = true;
        });

      }
    });
  }

  void _save() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    SharedPreferences prefs = await SharedPreferences.getInstance();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await flutterLocalNotificationsPlugin.cancelAll();

      var androidPlatformMealChannel = new AndroidNotificationDetails(
          'meal_channel', 'Meal notification', 'Remind you use this app',
          importance: Importance.Max, priority: Priority.High);
      var iOSPlatformMealChannel = new IOSNotificationDetails();
      var platformMealChannel = new NotificationDetails(
          androidPlatformMealChannel, iOSPlatformMealChannel);
      //
      int i = 0;
      _goalItems.forEach((type, item) async {
        if (item.enable) {
          prefs.setInt('rmh$type', item.time.hour);
          prefs.setInt('rmm$type', item.time.minute);
          await flutterLocalNotificationsPlugin.showDailyAtTime(
              i++,
              'Remind',
              'Time to $type',
              Time(item.time.hour, item.time.minute, 0),
              platformMealChannel);
        } else {
          prefs.remove('rmh$type');
          prefs.remove('rmm$type');
        }
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Set Reminders"),
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
                _buildItemCard(
                  item: _goalItems['water'],
                  name: 'WATER',
                  defaultTime: TimeOfDay(hour: 7, minute: 0),
                ),
                _buildItemCard(
                    item: _goalItems[DailyMealSection.BREAKFAST],
                    name: 'BREAKFAST',
                    defaultTime: TimeOfDay(hour: 7, minute: 0)),
                _buildItemCard(
                    item: _goalItems[DailyMealSection.LUNCH],
                    name: 'LUNCH',
                    defaultTime: TimeOfDay(hour: 12, minute: 0)),
                _buildItemCard(
                    item: _goalItems[DailyMealSection.DINNER],
                    name: 'DINNER',
                    defaultTime: TimeOfDay(hour: 18, minute: 0)),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(
      {ReminderCardItem item, String name, TimeOfDay defaultTime}) {
    final format = DateFormat("HH:mm");
    return Card(
      elevation: 0,
      borderOnForeground: true,
      margin: EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            trailing: Switch(
              value: item.enable,
              onChanged: (v) async {
                if (v) {
                  TimeOfDay time = await showTimePicker(
                      context: context, initialTime: item.time ?? defaultTime);
                  setState(() {
                    item.time = time ?? defaultTime;
                    item.enable = v;
                  });
                } else {
                  setState(() {
                    item.time = defaultTime;
                    item.enable = v;
                  });
                }
              },
            ),
            title: Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "OpenSans"),
            ),
            subtitle: Text(!item.enable
                ? 'off'
                : 'at ${item.time.hour}:${item.time.minute}'),
          ),
        ],
      ),
    );
  }

  Future<int> _showDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Every 15 minutes"),
              onTap: () => Navigator.pop(context, 15),
            ),
            ListTile(
              title: Text("Every 30 minutes"),
              onTap: () => Navigator.pop(context, 30),
            ),
            ListTile(
              title: Text("Every hours"),
              onTap: () => Navigator.pop(context, 60),
            ),
            ListTile(
              title: Text("Every 2 hours"),
              onTap: () => Navigator.pop(context, 120),
            ),
            ListTile(
              title: Text("Every 3 hours"),
              onTap: () => Navigator.pop(context, 180),
            ),
            ListTile(
              title: Text("Every 4 hours"),
              onTap: () => Navigator.pop(context, 240),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterCard({ReminderWaterCardItem item, String name}) {
    return Card(
      elevation: 0,
      borderOnForeground: true,
      margin: EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            trailing: Switch(
              value: item.enable,
              onChanged: (v) async {
                if (v) {
                  int m = await _showDialog(context);
                  setState(() {
                    item.minutes = m ?? 0;
                    item.enable = v;
                  });
                } else {
                  setState(() {
                    item.minutes = 0;
                    item.enable = v;
                  });
                }
              },
            ),
            title: Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "OpenSans"),
            ),
            subtitle:
                Text(!item.enable ? 'off' : 'every ${item.minutes} minutes'),
          ),
        ],
      ),
    );
  }
}

class ReminderCardItem {
  bool enable = false;
  TimeOfDay time;
}

class ReminderWaterCardItem {
  bool enable = false;
  int minutes;
}
