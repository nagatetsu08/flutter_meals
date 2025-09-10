import 'package:flutter_meals/providers/meals_provider.dart';
import 'package:flutter_meals/screens/filters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan
}

class FiltersNotify extends StateNotifier<Map<Filter, bool>> {
  // 親クラスの初期化を呼び出したい時の特有の書き方
  FiltersNotify() : super({
      Filter.glutenFree: false,
      Filter.lactoseFree: false,
      Filter.vegetarian: false,
      Filter.vegan: false
  });

  void setFilter(Filter filter, bool isActive) {
    // 直接弄るのは禁止
    // 必ず新しいMapを作成し、その中にstateを展開し、引数の値で上書きする
    state = {
      ...state,           // ここまでは既存のstateをコピーして展開
      filter: isActive,   // 同じキーを持つところに上書きになる
    };

    // 以下の書き方はNG(直接上書き)
    // state[filter] = isAcitve;
  }

  // 現時点のフィルター値をすべて上書き保存する。
  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }
}

final filtersProvider = StateNotifierProvider<FiltersNotify, Map<Filter, bool>>((ref) => FiltersNotify());

// 他のプロバイダー（mealsProvider、filtersProvider）に依存するプロバイダー
// ただのプロバイダーを使っているのは、このプロバイダーの中で専用のStateを管理していないこと、また、このプロバイダーがStateNotifierProviderの
// 変更に連動して動いてくれればいいだけ（こいつ自体は何の通知もしなくていい）
final filterdMealProvider = Provider((ref) {
  // 以下2つのプロバイダーをwatchしているのでいずれかに変更があるとこの処理が動く。
  // mealsProviderはダミーデータだけを返すのでwatchでなくてもいいが、安全性を考慮してwatchで実装した方がいい。（初期化メソッドないでもないので）
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
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
});