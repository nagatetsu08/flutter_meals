import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_meals/screens/categories.dart';
import 'package:flutter_meals/screens/filters.dart';
import 'package:flutter_meals/screens/meals.dart';
import 'package:flutter_meals/widgets/main_drawer.dart';

import 'package:flutter_meals/providers/meals_provider.dart';
import 'package:flutter_meals/providers/favorites_provider.dart';
import 'package:flutter_meals/providers/filters_provider.dart';

// 先頭にkがつくと、flutterでグローバル変数扱いになる
const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

  class TabScreen extends ConsumerStatefulWidget{
    const TabScreen({super.key});

  @override
  ConsumerState<TabScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends ConsumerState<TabScreen> {

  int _selectedPageIndex = 0;

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
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          // river_podで渡す変数の中身をprovier管理下においたので、変数を渡さなくて良くなり、const化できるようになった
          builder: (ctx) => const FiltersScreen(
          ),
        ),
      );      
      // 余談だが、pushをpushReplacementにすると戻る操作をできなくすることができる。
    } else {
      // elseにくる=今Category画面にいるのでドロワーを閉じるだけでいい
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {

    // build配下ではデータの読み込みが1回だけだとしても、Rivercpodの公式にはwatchを使うように指示がある。
    final meals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(filtersProvider);

    final availableMeals = meals.where((meal) {
      // グルテンフリーのフラグが渡ってきていて、かつ個々のmealがグルテンフリーフラグを持っていたら
      // 初期値を上で設定しているからnullになりえない。したがって、!をつけていい
      // trueが返ったときだけ表示される。表示したいのは以下2パターン
      // 1._selectedFilters[Filter.glutenFree]がtrueでない。
      // 2._selectedFilters[Filter.glutenFree]がtrueで、meal.isGlutenFreeがTrueのとき
      // 逆を返せば、selectedFilters[Filter.glutenFree]がtrueで、meal.isGlutenFreeがFalseのときだけ見せたくない（このときだけfalseを返せばいい）
      if(activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if(activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if(activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if(activeFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if(_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
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