import 'package:flutter/material.dart';
import 'package:flutter_meals/main.dart';
import 'package:flutter_meals/models/meal.dart';
import 'package:flutter_meals/providers/favorites_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ConsumerWidgetはStatelessWidgetの代わり
class MealDetailScreen extends ConsumerWidget{
  const MealDetailScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // RiverPod管理下のState変数を取得
    final favoriteMeals = ref.watch(favoriteMealsProvider);

    final isFavorite = favoriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            // 引数付きの関数を実行するためにあえて無名関数でラッピングしているだけなので、onPressed横の()には引数を入れない
            // 以下のような実行方法をvoid callbackという
            // onPressed: () {
            //   onToggleFavorite(meal);
            // },

            // イベントハンドラの中では継続的監視ではなく、一度だけ読み取って実行する、readを使う。
            // (watchを使うと変化があるたびにリビルドが走るので、不具合の温床になってしまうらしい)
            // 公式でもイベントハンドラ内ではreadを使うことを推奨している
            onPressed: () {
              final wasAdded = ref
                .read(favoriteMealsProvider.notifier)
                .toggleMealsFavoriteStatus(meal);
                
                ScaffoldMessenger.of(context).clearSnackBars(); // 初期化
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      wasAdded ? 'Meal added!!' : 'Meal removed!!',
                    ),
                  ),
                );
            },
            icon: Icon(isFavorite ? Icons.star : Icons.star_border),
          )
        ],
      ),
      // リスト形式で見せたいが、コンテンツ量が少なくてさほどスクロールしない（ちょっとしかしない）のであれば
      // SingleChildScrollView + Columnを使う。
      // 逆に結構増えていく場合はListViewを使う
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              meal.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 14),
            Text(
              'Ingredents', 
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 14),
            for (final ingredient in meal.ingredients)
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                )              
              ),
            const SizedBox(height: 24),
            Text(
              'Steps', 
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 14),
            for (final step in meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  step,
                  textAlign: TextAlign.center, //文章が長いと真ん中によらないので、TextAlign.centerでよせてやる
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  )              
                ),
              ),
          ],
        ),
      ),

    );
  }
}