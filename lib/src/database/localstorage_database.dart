

import 'package:localstorage/localstorage.dart';

class LocalStorageDatabase {
  static LocalStorageDatabase? _instance;
  static LocalStorage? _localStorage;
  static bool isReady = false;

  factory LocalStorageDatabase() {
    _instance ??= LocalStorageDatabase._internalConstructor();
    return _instance!;
  }

  LocalStorageDatabase._internalConstructor() {
    _localStorage = LocalStorage('forkifyAppData');
    _checkIsReady();
  }

  Future<void> _checkIsReady() async {
    if (isReady) {
      return;
    }

    try {
      isReady = await _localStorage!.ready;
    } catch (e) {
      isReady = false;
    }
  }

  Future setKey(String key, dynamic data) async {
    await _checkIsReady();

    if (isReady) {
      await _localStorage!.setItem(key, data);
    }
  }

  Future<dynamic> getKey(String key) async {
    await _checkIsReady();

    if (isReady) {
      return _localStorage!.getItem(key);
    }

    return null;
  }

  Future<Map<String, dynamic>> getKeys(keys) async {
    await _checkIsReady();

    if (isReady) {
      final Map<String, dynamic> data = {};
      for (var key in keys) {
        data[key] = _localStorage!.getItem(key);
      }
      return data;
    }

    return {};
  }

  Future removeKey(String key) async {
    await _checkIsReady();

    if (isReady) {
      await _localStorage!.deleteItem(key);
    }
  }

  Future removeKeys(List<String> keys) async {
    await _checkIsReady();

    if (isReady) {
      for (var key in keys) {
        await _localStorage!.deleteItem(key);
      }
    }
  }
}
