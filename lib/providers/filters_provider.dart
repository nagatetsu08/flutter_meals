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