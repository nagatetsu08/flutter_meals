import 'package:flutter/material.dart';

// 状態監視自体はこの画面では行わず、mainであるtabs.dartでまとめて行う。
class MainDrawer extends StatelessWidget{
  const MainDrawer({
    super.key,
    required this.onSelectScreen
  });

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

              )
            ),
            child: Row(
              children: [
                Icon(Icons.fastfood, size: 48, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: 18,),
                Text('Cooking up', style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary
                ))  
              ],
            )
          ),
          // Push通知を一覧表示しているやつの１個１個の行をイメージしてもらえばいい
          ListTile(
            //タイトル横にアイコンをつけてくれる
            leading: Icon(
              Icons.restaurant,
              size: 26,
              color: Theme.of(context).colorScheme.onSurface
            ),
            title: Text(
              'Meals', 
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
              )
            ),
            onTap: () {
              onSelectScreen('meals');
            },
          ),
          ListTile(
            //タイトル横にアイコンをつけてくれる
            leading: Icon(
              Icons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.onSurface
            ),
            title: Text(
              'Filters', 
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
              )
            ),
            onTap: () {
              onSelectScreen('filters');
            },
          ),
        ],
      ),
    );
  }
}