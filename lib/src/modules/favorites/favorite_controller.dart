import 'package:forkify_app/src/helpers/messages.dart';
import 'package:forkify_app/src/model/dishe.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FavoriteController with MessageStateMixin {

  final dishe = signal(<Dishes>[]);
  final _isLoading = signal(true);

  bool get loading => _isLoading();
  List<Dishes> get dishes => dishe();

  void removeFavoriteDishe(String id) {
    _isLoading.value = false;
    final index = dishes.indexWhere((element) => element.recipeId == id);
    dishes[index].isFavorite = !dishes[index].isFavorite;
    dishes.removeWhere((element) => element.recipeId == id);
    dishe.value = dishes;
    _isLoading.value = true;
  }
}
