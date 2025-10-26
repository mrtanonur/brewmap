import 'package:brewmap/features/maps/models/cafe_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesLocalDataProvider {
  static Box<CafeModel>? box;

  static Future openBox() async {
    box = await Hive.openBox("favorites");
  }

  Future add(CafeModel cafeModel) async {
    await box!.put(cafeModel.id, cafeModel);
  }

  Future delete(String key) async {
    await box!.delete(key);
  }

  CafeModel? read(CafeModel cafeModel) {
    return box!.get(cafeModel.id);
  }

  Future clear() async {
    await box!.clear();
  }

  List<CafeModel>? readAll() {
    return box!.values.toList();
  }
}
