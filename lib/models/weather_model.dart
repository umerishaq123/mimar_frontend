class WeatherModel {
  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final String description;
  final int humidity;
  final double windSpeed;
  final DateTime timestamp;

  WeatherModel({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.timestamp,
  });

  // From JSON
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['city'],
      country: json['country'],
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      description: json['description'],
      humidity: json['humidity'],
      windSpeed: (json['wind_speed'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'temperature': temperature,
      'feels_like': feelsLike,
      'description': description,
      'humidity': humidity,
      'wind_speed': windSpeed,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'WeatherModel(city: $city, country: $country, temperature: $temperature°C, '
        'feelsLike: $feelsLike°C, description: $description, humidity: $humidity%, '
        'windSpeed: $windSpeed m/s, timestamp: $timestamp)';
  }
}
