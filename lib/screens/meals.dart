import 'package:flutter/material.dart';
import 'package:flutter_meals/models/meal.dart';
import 'package:flutter_meals/screens/meal_detail.dart';
import 'package:flutter_meals/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key, 
    required this.title,
    required this.meals 
  });

  final String title;
  final List<Meal> meals; 

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => 
          MealDetailScreen(
            meal: meal
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, //余ったスペースは詰めてしまう。
        children: [
          Text(
            'data is nothing!!',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16,),
          Text(
            'Try selecting another categories',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ]
      ),
    );


    if(meals.isNotEmpty) {
      content = ListView.builder(
        itemCount: meals.length, // flutterのListViewでは使う使わないに限らず、itemCountmを定義しておかないとエラーになる
        itemBuilder: (ctx, index) => 
          MealItem(
            meal: meals[index],
            onSelectMeal: (meal) {
              selectMeal(context, meal);
            },
          ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        //変数だからconst化できない
        title: Text(title),
      ),
      body: content
    );
  }
}