class AirportItem {
  final String name;
  final String iataCode;
  final String cityCode;
  final String countryCode;

  AirportItem({
    this.name,
    this.iataCode,
    this.cityCode,
    this.countryCode,
  });

  factory AirportItem.fromJson(Map<String, dynamic> data) {
    return AirportItem(
      name: data['name'],
      iataCode: data['code'],
      cityCode: data['city_code'],
      countryCode: data['country_code'],
    );
  }
}
