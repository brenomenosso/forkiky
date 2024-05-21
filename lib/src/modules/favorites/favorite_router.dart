import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:forkify_app/src/modules/favorites/favorite_page.dart';
import 'package:forkify_app/src/modules/favorites/favorite_controller.dart';

class FavoriteRouter extends FlutterGetItModulePageRouter{

  const FavoriteRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
    Bind.lazySingleton((i) => FavoriteController()),
  ];

  @override
  WidgetBuilder get view =>  (_) => const FavoritePage();

}