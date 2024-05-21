import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:forkify_app/src/components/card_dishe.dart';
import 'package:forkify_app/src/components/dots_loadings.dart';
import 'package:forkify_app/src/helpers/messages.dart';
import 'package:forkify_app/src/model/dishe.dart';
import 'package:forkify_app/src/modules/favorites/favorite_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FavoritePage extends StatefulWidget {

  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with MessageViewMixin {
  final TextEditingController _searchDisheEC = TextEditingController();
  final controller = Injector.get<FavoriteController>();

  @override
  void initState() {
    super.initState();
    messageListener(controller);
  }

  @override
  void dispose() {
    _searchDisheEC.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    var args = ModalRoute.of(context)!.settings.arguments as List<Dishes>;
    controller.dishe.value = args;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        setState(() {
          
        });
        Navigator.pop(context, controller.dishes);
      },
      child: Scaffold(
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
                  Watch((_) {
                    return controller.loading
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: controller.dishes.length,
                                itemBuilder: (context, index) {
                                  var dishe = controller.dishes[index];
                                  return GestureDetector(
                                    onDoubleTap: () => controller
                                        .removeFavoriteDishe(
                                          dishe),
                                    child: CardDishe(
                                      publisher: dishe.publisher,
                                      title: dishe.title,
                                      sourceUrl: dishe.sourceUrl,
                                      recipeId: dishe.recipeId,
                                      imageUrl: dishe.imageUrl,
                                      isFavorite: dishe.isFavorite,
                                    ),
                                  );
                                }),
                          )
                        : const Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  LoadingDots(title: 'Carregando pratos...'),
                                ]),
                          );
                  }),
                ],
              ),
            ),
          ),),
    );
  }
}
