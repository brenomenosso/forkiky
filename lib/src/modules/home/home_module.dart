import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:forkify_app/src/modules/favorites/favorite_page.dart';
import 'package:forkify_app/src/modules/favorites/favorite_controller.dart';
import 'package:forkify_app/src/modules/home/home_controller.dart';
import 'package:forkify_app/src/modules/home/home_page.dart';
import 'package:forkify_app/src/repositories/dishe_repository.dart';
import 'package:forkify_app/src/repositories/dishe_repository_impl.dart';
import 'package:forkify_app/src/services/dishe_service.dart';

class HomeModule extends FlutterGetItModule{

  @override
  List<Bind<Object>> get bindings => [
    Bind.lazySingleton<DisheRepository>((i) => DisheRepositoryImpl(restClient: i())),
    Bind.lazySingleton((i) => HomeController(repository: i())),
    Bind.lazySingleton((i) => FavoriteController()),
    Bind.lazySingleton((i) => DisheService(homeController: i(), favoriteController: i())),
  ];

  @override
  String get moduleRouteName => '/home';

  @override
  Map<String, WidgetBuilder> get pages => {
    '/': (_) => const HomePage(),
    '/favorites': (_) => const FavoritePage(),
  };

}