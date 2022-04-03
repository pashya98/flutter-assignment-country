class LanguageModel {
  String? code;
  String? name;
  String? native;
  bool isSelected;
  LanguageModel({this.code, this.name, this.native, this.isSelected = false});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
        code: json['code'],
        name: json['name'],
        native: json['native'],
        isSelected: false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'code': code,
      'name': name,
      'native': native,
      'isSelected': false
    };
    return data;
  }
}
