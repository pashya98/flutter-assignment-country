import 'package:cbnits/model/language_model.dart';

class CountryModel {
  String? code;
  String? currency;
  String? emoji;
  String? name;
  String? phone;
  List<LanguageModel>? languages;

  CountryModel(
      {this.code,
      this.currency,
      this.emoji,
      this.name,
      this.phone,
      this.languages});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      code: json['code'],
      currency: json['currency'],
      emoji: json['emoji'],
      name: json['name'],
      phone: json['phone'],
      languages: json['languages'] != null
          ? (json['languages'] as List)
              .map((i) => LanguageModel.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['currency'] = currency;
    data['emoji'] = emoji;
    data['name'] = name;
    data['phone'] = phone;
    if (languages != null) {
      data['languages'] = languages?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
