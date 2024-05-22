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
  final _dishesFavorites = signal(<Dishes>[]);
  final _isLoading = signal(false);
  final _isLogged = signal(false);

  bool get loading => _isLoading();
  List<Dishes> get dishes => _dishes();
  List<Dishes> get dishesFavorites => _dishesFavorites();

  Future<void> getAllDishes(
      [List<Dishes>? favorites, bool? removeFavorites]) async {
    _isLoading.value = true;

    List<Dishes> newDishesFavorites = [...dishesFavorites];

    //Valido para quando entrar no app 1x, remover loading de transição entre as telas de favoritos e home
    if (favorites?.isEmpty == true && dishes.isEmpty == true) {
      _isLoading.value = false;
      return;
    }

    //Valido para quando retornar da tela de favoritos e a lista estiver vazio, limpo a lista de favoritos
    if (favorites?.isEmpty == true) {
      dishesFavorites.clear();
      newDishesFavorites.clear();
      await LocalStorageDatabase().setKey('lastDishe', dishesFavorites);
    }

    //Para tratar quando volta da tela de favoritos
    if (favorites != null && removeFavorites == true) {

      //Pega a lista de receitas e remover todos os favoritos
      final listRemoveFavorite = dishes.map((e) {
        return e.copyWith(isFavorite: false);
      }).toList();

      //Pega a lista que retorna da tela de favoritos e se tiver alguma receita que é favorito do prato selecionado, eu coloco como favorito
      final list = listRemoveFavorite.map((e) {
        final index = favorites.indexWhere((element) => element.recipeId == e.recipeId);
        if (index != -1) {
          return e.copyWith(isFavorite: true);
        }
        return e;
      }).toList();

      // Crio uma lista alternativa da favorites e nela removo as receitas que não estão mais na lista de favoritos
      for (var savedFavorites in dishesFavorites) {
        final index = favorites.indexWhere((e) => e.recipeId == savedFavorites.recipeId);
        if (index == -1) {
          newDishesFavorites.remove(savedFavorites);
        }
      }

      //Atribuo a lista de pratos novamente
      _dishes.value = list;
      dishesFavorites.clear();
      _dishesFavorites.value = newDishesFavorites;
      _dishesFavorites.value = getFavorites();
      //Salvo localmente para ao reabrir o app trazer ja carregado, poderia ter usado SQFLite ou Hive para armazenar tbm
      //mas como é um app simples, optei por usar o LocalStorage
      //A tela da uma piscada por conta do await do localStorage, pois ele da um tempo siginificativo e cai no loading
      await LocalStorageDatabase().setKey('lastDishe', dishesFavorites);
      _isLoading.value = false;
    }
  }

  Future<void> setFavoriteDishe(Dishes value) async {
    _isLoading.value = true;
    //Percorro a lista de pratos e adiciono ou removo o prato favorito a partir dos 2 cliques
    final list = dishes.map((e) {
      if (e.recipeId == value.recipeId) {
        if (e.isFavorite == true) {
          dishesFavorites.removeWhere((element) => element.recipeId == e.recipeId);
        }
        return e.copyWith(isFavorite: !e.isFavorite);
      }
      return e;
    }).toList();

    _dishes.value = list;
    _dishesFavorites.value = getFavorites();
    await LocalStorageDatabase().setKey('lastDishe', dishesFavorites);
    _isLoading.value = false;
  }

  List<Dishes> getFavorites() {
    //Retorno lista de pratos favoritos para enviar a tela de favortitos
    //Ao reabrir o app
    if (dishes.isEmpty) {
      return dishesFavorites;
    }
    //Pego a nova lista de receitas e verifico se tem algum prato favorito ja salvo na lista de favoritos
    //Caso tiver, eu nao adiciono novamente, evitando duplicidade
    var list = dishes.where((element) => element.isFavorite).toList();
    for (var element in list) {
      final index = dishesFavorites.indexWhere((e) => e.recipeId == element.recipeId);
      if (index == -1) {
        dishesFavorites.add(element);
      }
    }
    return dishesFavorites;
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

  Future<void> getInitialDishes(String food) async {
    _isLoading.value = true;
    //Busco os pratos a partir do selecionado e atribuo a lista de pratos
    final result = await _repository.getDishes(food);
    switch (result) {
      case Left():
        showError('Erro ao buscar os pratos');
      case Right(value: List<Dishes> dishe):
        //Valido para que em uma nova busca, limpe a lista de pratos e evite lsita infinita
        if (dishes.isNotEmpty) {
          dishes.clear();
        }
        setFavoriteAfterLogin(dishe);
        _isLogged.value = true;
        _isLoading.value = false;
    }
  }

  setFavoriteAfterLogin(List<Dishes> recipes) {
    //Valido ao buscar nova lista de receitas, se tem algum prato favorito
    //Caso tenha, eu atribuo favorito para o mesmo na lista de receitas e ja listo marcado como favorito
   var result = recipes.map((element) {
      final index = dishesFavorites.indexWhere((e) => e.recipeId == element.recipeId);
      if (index != -1) {
        return element.copyWith(isFavorite: true);
      }
      return element;
    }).toList();
    dishes.addAll(result);
  }

  Future<void> getDishesLocalStorage() async {
    //Busco as receitas favoritadas localmente e atribuo a lista de favoritos ao entrar no app
    _isLoading.value = true;
    final result = await LocalStorageDatabase().getKey('lastDishe');
    if (result != null) {
      for (var element in result) {
        dishesFavorites.add(Dishes.fromJson(element));
      }
      _isLogged.value = true;
    }
    _isLoading.value = false;
  }
}
