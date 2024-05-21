import 'package:flutter/material.dart';
import 'package:forkify_app/src/components/card_modal_options.dart';
import 'package:forkify_app/src/helpers/messages.dart';
import 'package:forkify_app/src/utils/food_types.dart';

class FoodSelected extends StatefulWidget {
  const FoodSelected({super.key});

  @override
  State<FoodSelected> createState() => _FoodSelectedState();
}

class _FoodSelectedState extends State<FoodSelected> with MessageViewMixin {

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                  ...FoodTypes.types
                    .map(
                      (food) => CardModalOption(
                        option: food,
                        onTap: () {
                          _closeModal(context, food);
                        },
                      ),
                    )
                    .toList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
