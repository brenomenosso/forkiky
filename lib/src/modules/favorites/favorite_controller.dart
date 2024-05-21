import 'package:forkify_app/src/helpers/messages.dart';
import 'package:forkify_app/src/model/dishe.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FavoriteController with MessageStateMixin {

  final dishe = signal(<Dishes>[]);
  final _isLoading = signal(true);

  bool get loading => _isLoading();
  List<Dishes> get dishes => dishe();

  void removeFavoriteDishe(Dishes value) {
    _isLoading.value = false;

    final list = dishes.map((e) {
      if (e.recipeId == value.recipeId) {
        return e.copyWith(isFavorite: !e.isFavorite);
      }
      return e;
    }).toList();
    list.removeWhere((element) => element.recipeId == value.recipeId);
    dishe.value = list;
    _isLoading.value = true;
  }

  // void removeFavoriteDishe(Dishes value) {
  //   _isLoading.value = false;
  //   final index = dishes.indexWhere((element) => element.recipeId == id);
  //   //dishes[index].isFavorite = !dishes[index].isFavorite;
  //   dishes.removeWhere((element) => element.recipeId == id);
  //   dishe.value = dishes;
  //   _isLoading.value = true;
  // }
}
