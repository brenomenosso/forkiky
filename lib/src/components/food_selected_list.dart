import 'package:flutter/material.dart';
import 'package:forkify_app/src/components/card_modal_options.dart';
import 'package:forkify_app/src/helpers/messages.dart';
import 'package:forkify_app/src/utils/food_types.dart';

class FoodSelectedList extends StatefulWidget {
  const FoodSelectedList({super.key});

  @override
  State<FoodSelectedList> createState() => _FoodSelectedListState();
}

class _FoodSelectedListState extends State<FoodSelectedList> with MessageViewMixin {

  void _closeModal(BuildContext context, String food) {
    Navigator.pop(context, food);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:
            Text('Pratos', style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: FoodTypes.types.length,
            itemBuilder: (context, index) {
              final food = FoodTypes.types[index];
              return CardModalOption(
                option: food,
                onTap: () {
                  _closeModal(context, food);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
