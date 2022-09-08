import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const dbName = "dog_box";
  static final Box _box = Hive.box(dbName);

  static Future<void> setData<T>(StorageKey key, T value) async {
    await _box.put(key.name, value);
  }

  static T readData<T>(StorageKey key, {T? defaultValue}) {
    return _box.get(key.name, defaultValue: defaultValue);
  }

  static Future<void> removeData(StorageKey key) async {
    await _box.delete(key.name);
  }

  static Future<void> clear() async {
    await _box.clear();
  }
}

enum StorageKey {
  language,
  mode,
}