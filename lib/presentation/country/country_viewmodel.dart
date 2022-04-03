import 'package:cbnits/model/country_model.dart';
import 'package:cbnits/remote/service/country_service.dart';
import 'package:flutter/cupertino.dart';

class CountryViewModel extends ChangeNotifier {
  late final CountryService _countryService;

  List<CountryModel> _countyList = [];

  List<CountryModel> get countyList => _countyList;

  set countyList(List<CountryModel> value) {
    _countyList = value;
    notifyListeners();
  }

  List<CountryModel> _filteredCountyList = [];

  List<CountryModel> get filteredCountyList => _filteredCountyList;

  set filteredCountyList(List<CountryModel> value) {
    _filteredCountyList = value;
    notifyListeners();
  }

  int _loadingStatus = 0;

  int get loadingStatus => _loadingStatus;

  set loadingStatus(int value) {
    _loadingStatus = value;
    notifyListeners();
  }

  final TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  String _inputText = '';

  String get inputText => _inputText;

  set inputText(String value) {
    _inputText = value;
    notifyListeners();
  }

  String _filterText = '';

  String get filterText => _filterText;

  set filterText(String value) {
    _filterText = value;
    notifyListeners();
  }

  bool _isError = false;

  bool get isError => _isError;

  set isError(bool value) {
    _isError = value;
    notifyListeners();
  }

  CountryViewModel() {
    _countryService = CountryService();
  }

  void getAllCountries(Function(String message) onError) async {
    loadingStatus = 1;
    _countryService.getAllCountries().then((result) {
      result.sort((a, b) => a.name!.compareTo(b.name!));
      countyList = result;
      filteredCountyList = result;
      loadingStatus = 2;
    }).onError((error, stackTrace) {
      loadingStatus = 3;
      onError(error.toString());
    });
  }

  void onSearchChangeText(String input) {
    if (input.isNotEmpty) {
      var result = filteredCountyList
          .where((element) => element.code!.contains(input.toUpperCase()));
      isError = result.isEmpty;
      countyList = result.toList();
    } else {
      isError = false;
      countyList = filteredCountyList;
    }
  }

  void setLanguageFilter(String filterInput) {
    if (filterInput.isNotEmpty) {
      filterText = filterInput;
      var result = filteredCountyList.where((element) {
        if (element.languages!.isNotEmpty) {
          var languageResult = element.languages
              ?.where((languageElement) => languageElement.name == filterInput);
          return languageResult != null && languageResult.isNotEmpty;
        }
        return false;
      });
      countyList = result.toList();
    } else {
      countyList = filteredCountyList;
    }
  }

  void clearFilter() {
    isError = false;
    inputText = "";
    searchController.clear();
    filterText = "";
    countyList = filteredCountyList;
  }
}
