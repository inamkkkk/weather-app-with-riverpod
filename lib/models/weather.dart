class Weather {
  final String location;
  final double temperature;
  final String condition;

  Weather({
    required this.location,
    required this.temperature,
    required this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num).toDouble() - 273.15, // Convert from Kelvin to Celsius
      condition: json['weather'][0]['main'] ?? 'Unknown',
    );
  }
}
