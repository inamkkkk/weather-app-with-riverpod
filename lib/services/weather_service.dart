import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherService {
  final String apiKey = 'YOUR_API_KEY'; // Replace with your OpenWeatherMap API key

  Future<Weather> getWeatherData() async {
    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        String? city = placemarks.first.locality;
        if (city != null) {
          final String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';
          final response = await http.get(Uri.parse(apiUrl));

          if (response.statusCode == 200) {
            final json = jsonDecode(response.body);
            return Weather.fromJson(json);
          } else {
            throw Exception('Failed to load weather data: ${response.statusCode}');
          }
        } else {
          throw Exception('City not found');
        }
      } else {
        throw Exception('No placemarks found');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
