import 'package:flutter/material.dart';
import 'package:flutter_meals/models/meal.dart';
import 'package:flutter_meals/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget{
  const MealItem({
    super.key,
    required this.meal,
    required this.onSelectMeal,
  });

  final Meal meal;

  // ゲッター
  String get complexityText {
    // 名称の0桁目のみを取り出して大文字にし、あとは通常の値とくっつける
    return meal.complexity.name[0].toUpperCase() + meal.complexity.name.substring(1);
  }

  String get affordabilityText {
    // 名称の0桁目のみを取り出して大文字にし、あとは通常の値とくっつける
    return meal.affordability.name[0].toUpperCase() + meal.affordability.name.substring(1);
  }

  final void Function(Meal meal) onSelectMeal;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      // Stackウィジェットを使っているとshapeは無視されてしまうらしいので、
      // clipBehavior: Clip.hardEdgeで無理矢理ギザギザをだしてはみ出してるように見せて丸くするテクらしい。
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        // 引数を取りたい時は無名関数方式で書く
        onTap: () {
          onSelectMeal(meal);
        },
        // パーツの上にパーツを重ねていく。
        // 2D方向ではなく3D方向に重ねていく。
        child: Stack(
          children: [
            // ロードされるまではplaceholderのイメージが表示され、ロードが完了するとimageの画像が表示される。
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage), //flutter pub add transparent_image
              image: NetworkImage(meal.imageUrl),
              height: 200,            // イメージには高さを与えたほうがよい
              width: double.infinity, // 横幅目一杯使う
              fit: BoxFit.cover,      // アスペクト比を維持しつつ、上記で設定した高さと横幅をイメージが全体を覆うように
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right:0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      meal.title, 
                      maxLines: 2, 
                      textAlign: TextAlign.center,
                      softWrap: true,                   // テキストの折り返しをしてくれる
                      overflow: TextOverflow.ellipsis,  // テキストが長すぎた時に省略してくれる（3ドット）
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                          icon: Icons.schedule, 
                          label: '${meal.duration} min'
                        ),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          icon: Icons.work, 
                          label: complexityText
                        ),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          icon: Icons.money, 
                          label: affordabilityText
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}