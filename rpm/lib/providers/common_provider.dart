import 'package:flutter/material.dart';
import 'package:rpm/const/storage_keys.dart';
import 'package:rpm/models/entity_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonProvider extends ChangeNotifier {
  List<Entity> languageList = [];
  Entity? selectedLanguage;

  Future<void> loadLanguages() async {
    languageList.add(Entity(
      id: 0,
      code: "en",
      description: "English",
      type: "Language",
      parentId: 0,
    ));
    languageList.add(Entity(
      id: 0,
      code: "si",
      description: "සිංහල",
      type: "Language",
      parentId: 0,
    ));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(StorageKeys.LanguageCode)) {
      for (Entity item in languageList) {
        if (item.code == StorageKeys.LanguageCode) {
          setLanguage(item);
        }
      }
    } else {
      setLanguage(languageList[0]);
    }
    notifyListeners();
  }

  void setLanguage(Entity language) {
    selectedLanguage = language;
    notifyListeners();
  }
}
