import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

enum WeatherState {
  loading,
  data,
  error,
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  WeatherNotifier() : super(WeatherState.loading) {
    fetchWeather();
  }

  Weather? weather;
  final WeatherService _weatherService = WeatherService();

  Future<void> fetchWeather() async {
    state = WeatherState.loading;
    try {
      weather = await _weatherService.getWeatherData();
      state = WeatherState.data;
    } catch (e) {
      state = WeatherState.error;
    }
  }
}

final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((ref) => WeatherNotifier());
