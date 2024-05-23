import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:forkify_app/src/components/card_dishe.dart';
import 'package:forkify_app/src/components/dots_loadings.dart';
import 'package:forkify_app/src/components/food_selected_list.dart';
import 'package:forkify_app/src/components/list_empity.dart';
import 'package:forkify_app/src/database/localstorage_database.dart';
import 'package:forkify_app/src/helpers/messages.dart';
import 'package:forkify_app/src/model/dishe.dart';
import 'package:forkify_app/src/modules/home/home_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with MessageViewMixin {
  final TextEditingController _searchFoodEC = TextEditingController();
  final controller = Injector.get<HomeController>();

  @override
  void initState() {
    super.initState();
    messageListener(controller);
    getDishes();
  }

  @override
  void dispose() {
    _searchFoodEC.dispose();
    super.dispose();
  }

  void getDishes() async {
    var lastDishes = await LocalStorageDatabase().getKey('lastDishe');
    if (lastDishes != null) {
      await controller.getDishesLocalStorage();
    }
    _searchFoodEC.text = 'Clique para selecionar o nome do prato';
  }

  Future _getFood(BuildContext context) async {
    String? food = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FoodSelectedList(),
        ));
    if (food != null) {
      _searchFoodEC.text = food;
      await controller.getInitialDishes(food);
    }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _searchFoodEC,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () => _getFood(context),
              ),
              const SizedBox(height: 10),
              Watch((_) {
                return controller.loading
                    ? const Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              LoadingDots(title: 'Carregando pratos...')
                            ]),
                      )
                    : controller.dishes.isEmpty
                        ? const Expanded(child: Center(child: ListEmpityCard()))
                        : Expanded(
                            child: ListView.builder(
                              itemCount: controller.dishes.length,
                              itemBuilder: (context, index) {
                                var dishe = controller.dishes[index];
                                return GestureDetector(
                                  onDoubleTap: () =>
                                      controller.setFavoriteDishe(dishe),
                                  child: CardDishe(
                                    publisher: dishe.publisher,
                                    title: dishe.title,
                                    sourceUrl: dishe.sourceUrl,
                                    recipeId: dishe.recipeId,
                                    imageUrl: dishe.imageUrl,
                                    isFavorite: dishe.isFavorite,
                                  ),
                                );
                              },
                            ),
                          );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final navigator = Navigator.of(context);
          var favorites = controller.getFavorites();
          var value = await navigator
              .pushNamed('/home/favorites', arguments: favorites);
            await controller.getAllDishes(value as List<Dishes>, true);
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}
