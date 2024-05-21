import 'package:forkify_app/src/fp/either.dart';
import 'package:forkify_app/src/helpers/messages.dart';
import 'package:forkify_app/src/model/dishe.dart';
import 'package:forkify_app/src/repositories/dishe_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomeController with MessageStateMixin {
  HomeController({required DisheRepository repository})
      : _repository = repository;

  final DisheRepository _repository;

  final _dishes = signal(<Dishes>[]);
  final _dishesFiltered = signal(<Dishes>[]);
  final _isLoading = signal(false);
  final _isLogged = signal(false);

  bool get loading => _isLoading();
  List<Dishes> get dishes => _dishes();
  List<Dishes> get dishesFiltered => _dishesFiltered();

  void getAllDishes([List<Dishes>? newList, bool? removeFavorites]) {
    _isLoading.value = false;
    if (newList != null && removeFavorites == true) {
      for (var element in dishes) {
        element.isFavorite = false;
      }
      newList.map((e) {
        final index = dishes.indexWhere((element) => element.recipeId == e.recipeId);
        dishes[index].isFavorite = true;
      }).toList();
      _dishesFiltered.value = dishes;
      _isLoading.value = true;
    }
    _dishesFiltered.value = dishes;
    _isLoading.value = true;
  } 

  void setFavoriteDishe(String id) {
    _isLoading.value = false;
    final index = dishes.indexWhere((element) => element.recipeId == id);
    dishes[index].isFavorite = !dishes[index].isFavorite;
    _dishes.value = dishes;
    _isLoading.value = true;
  }

  List<Dishes> getFavorites() {
     return dishesFiltered.where((element) => element.isFavorite).toList();
  }

  void search(String value) {
     _isLoading.value = false;
    final shides = dishes.where((element) {
      return element.title.toLowerCase().contains(value.toLowerCase());
    }).toList();

    _dishesFiltered.value = shides;
    _isLoading.value = true;
  }

  Future<void> getDishes() async {
    final result = await _repository.getDishes();
    switch (result) {
      case Left():
        showError('Erro ao buscar os pratos');
      case Right(value: List<Dishes> dishe):
        dishes.addAll(dishe);
        dishesFiltered.addAll(dishe);
        _isLogged.value = true;
        _isLoading.value = true;
    }
  }
}
