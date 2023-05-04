import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitalrpm/const/storage_keys.dart';
import 'package:vitalrpm/models/entity_model.dart';

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
      id: 2,
      code: "si",
      description: "සිංහල",
      type: "Language",
      parentId: 0,
    ));
    languageList.add(Entity(
      id: 2,
      code: "ta",
      description: "தமிழ்",
      type: "Language",
      parentId: 0,
    ));
    languageList.add(Entity(
      id: 3,
      code: "ar",
      description: "عربي",
      type: "Language",
      parentId: 0,
    ));
    languageList.add(Entity(
      id: 4,
      code: "ko",
      description: "한국인",
      type: "Language",
      parentId: 0,
    ));
    languageList.add(Entity(
      id: 5,
      code: "hi",
      description: "हिंदी",
      type: "Language",
      parentId: 0,
    ));
    languageList.add(Entity(
      id: 6,
      code: "fr",
      description: "Français",
      type: "Language",
      parentId: 0,
    ));
    languageList.add(Entity(
      id: 7,
      code: "ms",
      description: "Malay",
      type: "Language",
      parentId: 0,
    ));
    languageList.add(Entity(
      id: 8,
      code: "id",
      description: "Bahasa",
      type: "Language",
      parentId: 0,
    ));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(StorageKeys.languageCode)) {
      for (Entity item in languageList) {
        if (item.code == StorageKeys.languageCode) {
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
