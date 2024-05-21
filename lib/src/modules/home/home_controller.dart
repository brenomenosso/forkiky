import 'package:forkify_app/src/database/localstorage_database.dart';
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
  final _isLoading = signal(false);
  final _isLogged = signal(false);

  bool get loading => _isLoading();
  List<Dishes> get dishes => _dishes();

  Future<void> getAllDishes([List<Dishes>? favorites, bool? removeFavorites]) async {
    _isLoading.value = true;

    if (favorites != null && removeFavorites == true) {

      //Pegar a lista de pratos e remover todos os favoritos
      final listRemoveFavorite = dishes.map((e) {
        return e.copyWith(isFavorite: false);
      }).toList();

     //Pego a lista que retorno da tela anterior e se tiver algum prato que é favorito ainda, eu coloco como favorito
     final list = listRemoveFavorite.map((e) {
        final index = favorites.indexWhere((element) => element.recipeId == e.recipeId);
        if (index != -1) {
          return dishes[index].copyWith(isFavorite: true);
        }
        return e;
      }).toList();

      //Atribuo a lista de pratos novamente
      _dishes.value = list;
      //Salvo localmente para ao reabrir o app trazer ja carregado, poderia ter usado SQFLite ou Hive para armazenar tbm
      //mas como é um app simples, optei por usar o LocalStorage
      //A tela da uma piscada por conta do await do localStorage, pois ele da um tempo siginificativo e cai no loading
      await LocalStorageDatabase().setKey('lastDishe', dishes);
      _isLoading.value = false; 
    }
  }

  Future<void> setFavoriteDishe(Dishes value) async {
    _isLoading.value = true;
    //Percorro a lista de pratos e adiciono ou removo o prato favorito a partir dos 2 cliques
    final list = dishes.map((e) {
      if (e.recipeId == value.recipeId) {
        return e.copyWith(isFavorite: !e.isFavorite);
      }
      return e;
    }).toList();

    _dishes.value = list;
    await LocalStorageDatabase().setKey('lastDishe', dishes);
    _isLoading.value = false;
  }

  List<Dishes> getFavorites() {
    //Retorno lista de pratos favoritos para enviar a tela de favortitos
    return dishes.where((element) => element.isFavorite).toList();
  }

  void search(String value) {
    _isLoading.value = true;
    //Filtro a lista de receitas a partir do texto digitado
    //removido o text que fazia o filtro, pois não era necessario
    //porem vou deixar para mostrar que é possivel fazer o filtro
    final shides = dishes.where((element) {
      return element.title.toLowerCase().contains(value.toLowerCase());
    }).toList();

    _dishes.value = shides;
    _isLoading.value = false;
  }

  Future<void> getDishes(String food) async {
    _isLoading.value = true;
    //Busco os pratos a partir do selecionado e atribuo a lista de pratos
    final result = await _repository.getDishes(food);
    switch (result) {
      case Left():
        showError('Erro ao buscar os pratos');
      case Right(value: List<Dishes> dishe):
        dishes.addAll(dishe);
        await LocalStorageDatabase().setKey('lastDishe', dishes);
        _isLogged.value = true;
        _isLoading.value = false;
    }
  }

  Future<void> getDishesDatabase() async {
    //Busco os pratos salvos localmente e atribuo a lista de pratos ao entrar no app
    _isLoading.value = true;
    final result = await LocalStorageDatabase().getKey('lastDishe');
    if (result != null) {
      for (var element in result) {
        dishes.add(Dishes.fromJson(element));
      }
      _isLogged.value = true;
    }
    _isLoading.value = false;
  }
}
