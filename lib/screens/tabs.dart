import 'package:flutter/material.dart';
import 'package:flutter_meals/models/meal.dart';
import 'package:flutter_meals/screens/categories.dart';
import 'package:flutter_meals/screens/meals.dart';

class TabScreen extends StatefulWidget{
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends State<TabScreen> {

  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];

  void _showInfoMessage(String message) {
    // 画面の下からにょきっとでてくるやつ
    ScaffoldMessenger.of(context).clearSnackBars(); // 初期化
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,

        ),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    // containsはオブジェクト丸ごと渡す必要がある
    final isExisting = _favoriteMeals.contains(meal);

    if(isExisting == true) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage('Marked as favorite');
    }
  }


  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget activePage = CategoriesScreen(onToggleFavorite: _toggleMealFavoriteStatus);
    var activePageTitle = 'Categories';

    if(_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        // ここでも渡すのは関数定義のみ（引数まで定義しなくてOK）
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle)
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex, // 選んだタブがハイライトされる

        // なぜここに引数付きで定義しなくていいかというと、BottomNavigationBarのonTap Functionが
        // 実行時に自動的にindexを渡すから。(もっというと、型があっていると自動的に引数を渡すという仕様らしい)
        // フォーカスを合わせるとFunction(int)? onTapとあり、Function(int)を返すか or 関数自体がnullかという解釈
        onTap: _selectedPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites'
          ),          
        ]
      ),
    );
  }
}