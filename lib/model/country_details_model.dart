class CountryModel {
  String? code;
  String? currency;
  String? emoji;
  String? emojiU;
  String? name;
  String? native;
  String? phone;

  CountryModel(
      {this.code,
      this.currency,
      this.emoji,
      this.emojiU,
      this.name,
      this.native,
      this.phone});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      code: json['code'],
      currency: json['currency'],
      emoji: json['emoji'],
      emojiU: json['emojiU'],
      name: json['name'],
      native: json['native'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['currency'] = currency;
    data['emoji'] = emoji;
    data['emojiU'] = emojiU;
    data['name'] = name;
    data['native'] = native;
    data['phone'] = phone;
    return data;
  }
}
