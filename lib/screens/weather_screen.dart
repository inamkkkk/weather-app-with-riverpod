import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: switch (weatherState) {
          WeatherState.loading => const CircularProgressIndicator(),
          WeatherState.error => const Text('Failed to load weather data'),
          WeatherState.data => _buildWeatherData(ref),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(weatherProvider.notifier).fetchWeather();
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildWeatherData(WidgetRef ref) {
    final weatherData = ref.read(weatherProvider.notifier).weather;
    if (weatherData == null) {
      return const Text('No weather data available.');
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Location: ${weatherData.location}'),
          Text('Temperature: ${weatherData.temperature}°C'),
          Text('Condition: ${weatherData.condition}'),
        ],
      ),
    );
  }
}
