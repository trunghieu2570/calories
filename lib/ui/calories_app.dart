import 'package:calories/blocs/auth/bloc.dart';
import 'package:calories/blocs/favorite_foods/bloc.dart';
import 'package:calories/blocs/favorite_meals/bloc.dart';
import 'package:calories/blocs/favorite_recipes/bloc.dart';
import 'package:calories/repositories/auth_repository.dart';
import 'package:calories/ui/foods_screen.dart';
import 'package:calories/ui/screens/food/create_food_screen.dart';
import 'package:calories/ui/screens/food/food_detail_screen.dart';
import 'package:calories/ui/screens/food/food_search_screen.dart';
import 'package:calories/ui/screens/meal/meal_search_screen.dart';
import 'package:calories/ui/screens/recipe/recipe_detail_screen.dart';
import 'package:calories/ui/screens/recipe/recipe_search_screen.dart';
import 'package:calories/ui/splash_screen.dart';
import 'package:calories/ui/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'diary_screen.dart';
import 'screens/meal/create_meal_screen.dart';
import 'screens/meal/meal_detail_screen.dart';
import 'screens/recipe/create_recipe_screen.dart';

class MyApp extends StatelessWidget {
  final AuthRepository _userRepository;

  MyApp({Key key, @required AuthRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

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
                }
                if (state is Authenticated) {
                  BlocProvider.of<FavoriteFoodsBloc>(context)
                      .add(LoadFavoriteFoods());
                  BlocProvider.of<FavoriteRecipesBloc>(context)
                      .add(LoadFavoriteRecipes());
                  BlocProvider.of<FavoriteMealsBloc>(context)
                      .add(LoadFavoriteMeals());
                  return MyHomePage(title: "Hom nay");
                }
                return Container();
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

  SystemUiOverlayStyle systemUiOverlayStyle = new SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.grey[50],
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.black54,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _reset();
    _selectedView = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _reset() {
    setState(() {
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    });
  }

  void _changeView(int index) {
    setState(() {
      _selectedView = index;
    });
  }

  @override
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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {});
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
            title: Text("Nhật ký"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining),
            title: Text("Đồ ăn"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            title: Text("Biểu đồ"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            title: Text("Hồ sơ"),
          ),
        ],
        onTap: _changeView,
        currentIndex: _selectedView,
      ),
    );
  }
}
