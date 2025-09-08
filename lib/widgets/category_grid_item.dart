import 'package:flutter/material.dart';
import 'package:flutter_meals/models/category.dart';

class CategoryGridItem extends StatelessWidget{
  const CategoryGridItem({
    super.key, required 
    this.category,required 
    this.onSelectCategory
  });

  final Category category;
  final void Function() onSelectCategory;

  @override
  Widget build(BuildContext context) {
    // InkWellという似たようなの物ある。これは、Webviewでみかけるタップした時に少し波紋が広がるような効果がでる（インク反応っていうらしい）
    // あとフィードバックもあるらしい。InkWellはタップに特化したやつらしい。
    // 一方、GestureDetectorはタップ以外の操作（ドラッグとかピンチアウトとかスライド）も検知できる。
    return InkWell(
      // ここで関数を指定する場所にonSelectCategoryという変数が使えているのは、
      // final void Function() onSelectCategoryというFunction型の変数に関数自体をいれているから。（=関数を定義しているのと同じ）
      onTap: () {
        onSelectCategory();
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            //グラデーションに使うカラー
            colors: [
              category.color.withValues(alpha: 0.55), 
              category.color.withValues(alpha: 0.9),
            ],
            begin: Alignment.topLeft,   // グラデーションの開始位置
            end:  Alignment.bottomRight // グラデーションの終了位置
          )
        ),
        child: Text(
          category.title, 
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          )
        )
      ),
    );
  }
}