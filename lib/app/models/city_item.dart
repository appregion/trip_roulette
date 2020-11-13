class City {
  final String name;
  final String code;
  final String countryCode;

  City({
    this.name,
    this.code,
    this.countryCode,
  });

  factory City.fromJson(Map<String, dynamic> data) {
    return City(
      name: data['name'],
      code: data['code'],
      countryCode: data['country_code'],
    );
  }
}
