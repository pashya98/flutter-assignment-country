import 'package:cbnits/model/language_model.dart';
import 'package:cbnits/remote/service/language_service.dart';
import 'package:flutter/cupertino.dart';

class LanguagesViewModel extends ChangeNotifier {
  late LanguageService _languageService;

  List<LanguageModel> _languageList = [];

  List<LanguageModel> get languageList => _languageList;

  set languageList(List<LanguageModel> value) {
    _languageList = value;
    notifyListeners();
  }

  int _loadingStatus = 0;

  int get loadingStatus => _loadingStatus;

  set loadingStatus(int value) {
    _loadingStatus = value;
    notifyListeners();
  }

  int languageFilter = -1;

  LanguagesViewModel() {
    _languageService = LanguageService();
  }

  void getAllLanguages(Function(String message) onError) async {
    loadingStatus = 1;
    _languageService.getAllLanguages().then((result) {
      loadingStatus = 2;
      languageList = result;
    }).onError((error, stackTrace) {
      loadingStatus = 3;
      onError(error.toString());
    });
  }

  void onSelectLanguage(int index) {
    languageList.asMap().forEach((key, value) {
      if (key == index) {
        if (languageList[key].isSelected) {
          languageFilter = -1;
          languageList[key].isSelected = false;
        } else {
          languageFilter = index;
          languageList[key].isSelected = true;
        }
      } else {
        languageList[key].isSelected = false;
      }
    });
    notifyListeners();
  }
}
