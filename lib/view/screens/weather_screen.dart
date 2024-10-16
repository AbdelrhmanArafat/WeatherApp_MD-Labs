import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController cityController = TextEditingController();
  final WeatherService weatherService = WeatherService();
  WeatherModel? weather;
  String? errorMessage;

  Future<void> fetchWeather() async {
    final city = cityController.text.trim();
    if (city.isEmpty) {
      setState(() {
        errorMessage = "Please enter a city name.";
      });
      return;
    }

    final weatherData = await weatherService.fetchWeather(city);

    if (weatherData != null) {
      setState(() {
        weather = weatherData;
        errorMessage = null;
      });
    } else {
      setState(() {
        errorMessage = "City not found or network error.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'City Name',
                hintText: 'Enter city name',
                prefixIcon: const Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: Colors.blue[50],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchWeather,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 60),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              )
            else if (weather != null)
              Column(
                children: [
                  Text(
                    'City: ${weather!.cityName}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Temperature: ${weather!.temperature}°C',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Description: ${weather!.description}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Image.network(
                    'https://openweathermap.org/img/w/${weather!.icon}.png',
                    width: 50,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
