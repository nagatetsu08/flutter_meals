import 'package:flutter_meals/data/dummy_data.dart';
import 'package:flutter_meals/models/meal.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Stateで管理する変数とそいつに対して変更を加えるメソッドをまとめて管理する

class FavoriteMealsNortifier extends StateNotifier<List<Meal>> {
  // 初期化時は空の配列
  // 親クラスの初期化を呼び出したい時の特有の書き方
  FavoriteMealsNortifier() : super([]);

  // 状態管理では既存のStateをいじくり回してそのまま使うことは許されない。
  // そのため、新しいStatusに前のやつを展開しつつ、追加したり、削除したり、変更したりして、最終的に
  // 新しいStateを作って返す
  bool toggleMealsFavoriteStatus(Meal meal) {
    final measlIsFavorite = state.contains(meal);

    if(measlIsFavorite) {
      // 既存のstateを編集したものを再度stateに入れ直している。
      // stateの名前を変えるとNG
      state = state.where((stateMeal) => stateMeal.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

// 状態が変化する場合はProviderではなく、StateNotifierを使う
final favoriteMealsProvider = StateNotifierProvider<FavoriteMealsNortifier, List<Meal>>((ref) {
  return FavoriteMealsNortifier();
});