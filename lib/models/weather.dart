class Weather {
  String city;
  int temperature;
  String icon;
  String main;
  int? airQualityIndex;

  Weather({
    required this.city,
    required this.temperature,
    required this.icon,
    required this.main,
    required this.airQualityIndex,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: json['main']['temp'].toInt(),
      icon: json['weather'][0]['icon'],
      main: json['weather'][0]['main'],
      airQualityIndex: json['airQualityIndex'],
    );
  }
}
