import 'package:calories/blocs/auth/bloc.dart';
import 'package:calories/blocs/daily_meals/daily_meals_bloc.dart';
import 'package:calories/blocs/favorite_foods/bloc.dart';
import 'package:calories/blocs/favorite_meals/bloc.dart';
import 'package:calories/blocs/favorite_recipes/favorite_recipes_bloc.dart';
import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/goals/goals_bloc.dart';
import 'package:calories/blocs/home_load/bloc.dart';
import 'package:calories/blocs/meal/bloc.dart';
import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/ui/foods_screen.dart';
import 'package:calories/ui/loading_screen.dart';
import 'package:calories/ui/login_screen.dart';
import 'package:calories/ui/screens/food/create_edit_food_screen.dart';
import 'package:calories/ui/screens/food/food_detail_screen.dart';
import 'package:calories/ui/screens/food/food_search_screen.dart';
import 'package:calories/ui/screens/meal/meal_search_screen.dart';
import 'package:calories/ui/screens/recipe/recipe_detail_screen.dart';
import 'package:calories/ui/screens/recipe/recipe_search_screen.dart';
import 'package:calories/ui/splash_screen.dart';
import 'package:calories/ui/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'diary_screen.dart';
import 'screens/goal/edit_goal_screen.dart';
import 'screens/meal/create_meal_screen.dart';
import 'screens/meal/meal_detail_screen.dart';
import 'screens/recipe/create_recipe_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.green,
          textTheme: TextTheme(
              title: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "OpenSans",
          ))),
      initialRoute: "/",
      routes: {
        '/': (context) => BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Uninitialized) {
                  return SplashScreen();
                } else if (state is Unauthenticated) {
                  return LoginScreen();
                } else if (state is Authenticated) {
                  return BlocProvider<HomeLoadBloc>(
                    create: (context) => HomeLoadBloc(
                      foodBloc: BlocProvider.of<FoodBloc>(context),
                      goalBloc: BlocProvider.of<GoalBloc>(context),
                      dailyMealBloc: BlocProvider.of<DailyMealBloc>(context),
                      mealBloc: BlocProvider.of<MealBloc>(context),
                      recipeBloc: BlocProvider.of<RecipeBloc>(context),
                      favoriteFoodsBloc:
                          BlocProvider.of<FavoriteFoodsBloc>(context),
                      favoriteMealsBloc:
                          BlocProvider.of<FavoriteMealsBloc>(context),
                      favoriteRecipesBloc:
                          BlocProvider.of<FavoriteRecipesBloc>(context),
                    )..add(StartHomeLoad()),
                    child: BlocBuilder<HomeLoadBloc, HomeLoadState>(
                      builder: (context, state) {
                        if (state is InitLoadState) {
                          return LoadingScreen();
                        } else if (state is HomeLoadedState) {
                          return MyHomePage(title: "Hom nay");
                        } else
                          return SplashScreen();
                      },
                    ),
                  );
                }
                return SplashScreen();
              },
            ),
        FoodSearchScreen.routeName: (context) => FoodSearchScreen(),
        RecipeSearchScreen.routeName: (context) => RecipeSearchScreen(),
        CreateRecipeScreen.routeName: (context) => CreateRecipeScreen(),
        FoodDetailScreen.routeName: (context) => FoodDetailScreen(),
        RecipeDetailScreen.routeName: (context) => RecipeDetailScreen(),
        CreateFoodScreen.routeName: (context) => CreateFoodScreen(),
        MealSearchScreen.routeName: (context) => MealSearchScreen(),
        MealDetailScreen.routeName: (context) => MealDetailScreen(),
        CreateMealScreen.routeName: (context) => CreateMealScreen(),
        EditGoalScreen.routeName: (context) => EditGoalScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int _counter = 0;
  int _selectedView = 0;
  List<Widget> _views;
  List<Widget> _floatingButtons;

/*   SystemUiOverlayStyle systemUiOverlayStyle = new SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.grey[50],
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.black54,
  ); */

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // _reset();
    _selectedView = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

/*   void _reset() {
    setState(() {
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    });
  } */

  void _changeView(int index) {
    setState(() {
      _selectedView = index;
    });
  }

/*   @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _reset();
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.suspending:
        // TODO: Handle this case.
        break;
    }
  } */

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _views = [
      new DiaryScreen(),
      new FoodsScreen(),
      Text("Hello World 3"),
      new ProfileScreen(),
    ];
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return _views.elementAt(_selectedView);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            title: Text("Diary"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining),
            title: Text("Favorite"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            title: Text("Graph"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            title: Text("Profile"),
          ),
        ],
        onTap: _changeView,
        currentIndex: _selectedView,
      ),
    );
  }
}
