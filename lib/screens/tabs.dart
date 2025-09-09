import 'package:flutter/material.dart';
import 'package:flutter_meals/data/dummy_data.dart';
import 'package:flutter_meals/models/meal.dart';
import 'package:flutter_meals/screens/categories.dart';
import 'package:flutter_meals/screens/filters.dart';
import 'package:flutter_meals/screens/meals.dart';
import 'package:flutter_meals/widgets/main_drawer.dart';

// 先頭にkがつくと、flutterでグローバル変数扱いになる
const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

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

  Map<Filter, bool> _selectedFilters = kInitialFilters;

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

  void _setScreen(String identifier) async {
    if(identifier == 'filters') {
      Navigator.of(context).pop(); //これがないと戻ってきた際にドロワーが開いた状態になってしまうので、先に呼び出しておく
      // 返ってきたときのアクションを同期的に扱うため、関数をasync化して、awaitで受け取る
      // 実はpushはFetureを返し、型も<T?>となっているので、わかっていれば返してくる型も指定できる。
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          // 変数渡しているからconstにできない
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );
      setState(() {
        _selectedFilters = result ?? kInitialFilters;  
      });
      
      // 余談だが、pushをpushReplacementにすると戻る操作をできなくすることができる。
    } else {
      // elseにくる=今Category画面にいるのでドロワーを閉じるだけでいい
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {

    final availableMeals = dummyMeals.where((meal) {
      // グルテンフリーのフラグが渡ってきていて、かつ個々のmealがグルテンフリーフラグを持っていたら
      // 初期値を上で設定しているからnullになりえない。したがって、!をつけていい
      // trueが返ったときだけ表示される。表示したいのは以下2パターン
      // 1._selectedFilters[Filter.glutenFree]がtrueでない。
      // 2._selectedFilters[Filter.glutenFree]がtrueで、meal.isGlutenFreeがTrueのとき
      // 逆を返せば、selectedFilters[Filter.glutenFree]がtrueで、meal.isGlutenFreeがFalseのときだけ見せたくない（このときだけfalseを返せばいい）
      if(_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if(_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if(_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if(_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    })
    .toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals
    );
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
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
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