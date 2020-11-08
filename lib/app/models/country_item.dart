class Country {
  final String name;
  final String countryCode;

  Country({this.name, this.countryCode});

  factory Country.fromJson(Map<String, dynamic> data) {
    return Country(
      name: data['name'],
      countryCode: data['code'],
    );
  }
}
