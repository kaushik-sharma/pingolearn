import 'package:hive/hive.dart';

final _stringBox = Hive.box<String>(name: 'strings');
final _integerBox = Hive.box<int>(name: 'integers');
final _doubleBox = Hive.box<double>(name: 'doubles');
final _booleanBox = Hive.box<bool>(name: 'booleans');
final _objectBox = Hive.box<Map<String, dynamic>>(name: 'objects');

class CachingService {
  const CachingService._();

  static const CachingService instance = CachingService._();

  void saveString(String key, String value) => _stringBox.put(key, value);

  String? getString(String key) => _stringBox.get(key);

  void saveInteger(String key, int value) => _integerBox.put(key, value);

  int? getInteger(String key) => _integerBox.get(key);

  void saveDouble(String key, double value) => _doubleBox.put(key, value);

  double? getDouble(String key) => _doubleBox.get(key);

  void saveBool(String key, bool value) => _booleanBox.put(key, value);

  bool? getBool(String key) => _booleanBox.get(key);

  void saveObject(String key, Map<String, dynamic> value) =>
      _objectBox.put(key, value);

  Map<String, dynamic>? getObject(String key) => _objectBox.get(key);

  void clear() {
    _stringBox.clear();
    _integerBox.clear();
    _doubleBox.clear();
    _booleanBox.clear();
    _objectBox.clear();
  }
}
