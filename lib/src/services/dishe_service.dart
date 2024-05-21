import 'package:forkify_app/src/modules/favorites/favorite_controller.dart';
import 'package:forkify_app/src/modules/home/home_controller.dart';

class DisheService {

  final HomeController homeController;
  final FavoriteController favoriteController;

  DisheService({required this.homeController, required this.favoriteController});

}