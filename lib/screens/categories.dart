import 'package:flutter/material.dart';
import 'package:flutter_meals/data/dummy_data.dart';
import 'package:flutter_meals/models/category.dart';
import 'package:flutter_meals/screens/meals.dart';
import 'package:flutter_meals/widgets/category_grid_item.dart';


class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  
  void _selectedCategory(BuildContext context, Category category) {

    final filterMeals = dummyMeals.where((meal) => meal.categories.contains(category.id)).toList();

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (ctx) => 
          MealsScreen(
            title: category.title, 
            meals: filterMeals
          )
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick your Category'),
      ),
      body: GridView(
        padding: const EdgeInsets.all(24),
        // どのようにアイテムを並べるか。
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,        // 横方向に２個アイテムを並べる
          childAspectRatio: 3 / 2,  // アスペクト比
          crossAxisSpacing: 20,     // アイテム間の横幅
          mainAxisSpacing: 20,      // アイテム間の縦幅 

        ),
        // children内ではfor文でも{}なしで定義しないといけない
        children: [
          for (final category in availableCategories) 
            CategoryGridItem(
              category: category,
              // 関数を渡す時は関数名を直で定義するのではなく、以下のように無名関数で囲う
              // もしくはfinal void Fucntion というFcuntion型を格納する変数に入れてしまえば、
              // onSelectCategory: 上記の変数名という形で使える
              onSelectCategory: () {
                _selectedCategory(context, category);
              })  
        ],
      )
    );
  }
}