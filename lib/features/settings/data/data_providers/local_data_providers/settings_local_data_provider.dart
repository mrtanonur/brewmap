import 'package:hive_flutter/hive_flutter.dart';

class SettingsLocalDataProvider {
  static Box? box;

  static Future openBox() async {
    box = await Hive.openBox("settings");
  }

  static Future add(String key, dynamic value) async {
    await box!.put(key, value);
  }

  static Future delete(String key) async {
    await box!.delete(key);
  }

  static dynamic read(String key) {
    return box!.get(key);
  }
}
