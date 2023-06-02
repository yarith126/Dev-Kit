import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static final Box _box1 = Hive.box('box1');
  static final Box _box2 = Hive.box('box2');
}
