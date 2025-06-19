import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_detection_app/consts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? weather;
  final TextEditingController cityController = TextEditingController();
  bool isCelsius = true;

  void fetchWeather(String cityName) async {
    try {
      Weather weatherData = await wf.currentWeatherByCityName(cityName);
      setState(() {
        weather = weatherData;
      });
    } catch (e) {
      setState(() {
        weather = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("City not found! Try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Welcome to Weather Detection ☀️",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF546E7A),
                    ),
                  ),
                  const SizedBox(height: 40),
                  buildSearchBar(),
                  const SizedBox(height: 30),
                  weather == null
                      ? Column(
                          children: const [
                            Text(
                              "Search a city to see its weather",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF90A4AE),
                              ),
                            ),
                          ],
                        )
                      : buildWeatherUI(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: cityController,
            style: const TextStyle(
              color: Color(0xFF546E7A),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: "Enter city name",
              hintStyle: const TextStyle(
                color: Color(0xFF90A4AE),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            if (cityController.text.trim().isNotEmpty) {
              fetchWeather(cityController.text.trim());
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.lightBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Icon(Icons.search),
        ),
      ],
    );
  }

  Widget buildWeatherUI() {
    return Column(
      children: [
        Text(
          weather?.areaName ?? '',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF37474F),
          ),
        ),
        const SizedBox(height: 10),
        dateTimeInfo(),
        const SizedBox(height: 30),
        weatherIcon(),
        const SizedBox(height: 10),
        temperatureDisplay(),
        const SizedBox(height: 20),
        toggleUnitSwitch(),
        const SizedBox(height: 30),
        infoBox(),
      ],
    );
  }

  Widget dateTimeInfo() {
    final DateTime now = weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 30,
            color: Color(0xFF455A64),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${DateFormat("EEEE").format(now)}, ${DateFormat("d MMM y").format(now)}",
          style: const TextStyle(color: Color(0xFF607D8B)),
        ),
      ],
    );
  }

  Widget weatherIcon() {
    return Column(
      children: [
        Image.network(
          "http://openweathermap.org/img/wn/${weather?.weatherIcon}@4x.png",
          height: 120,
        ),
        const SizedBox(height: 10),
        Text(
          weather?.weatherDescription ?? '',
          style: const TextStyle(fontSize: 20, color: Color(0xFF455A64)),
        ),
      ],
    );
  }

  Widget temperatureDisplay() {
    double temp = isCelsius
        ? weather?.temperature?.celsius ?? 0
        : (weather?.temperature?.celsius ?? 0) * 9 / 5 + 32;
    return Text(
      "${temp.toStringAsFixed(1)}° ${isCelsius ? 'C' : 'F'}",
      style: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: Color(0xFF263238),
      ),
    );
  }

  Widget toggleUnitSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("°C", style: TextStyle(color: Color(0xFF37474F))),
        Switch(
          value: isCelsius,
          onChanged: (val) {
            setState(() {
              isCelsius = val;
            });
          },
          activeColor: Colors.lightBlue,
        ),
        const Text("°F", style: TextStyle(color: Color(0xFF37474F))),
      ],
    );
  }

  Widget infoBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          infoRow(Icons.thermostat, "Max Temp",
              "${weather?.tempMax?.celsius?.toStringAsFixed(1)} °C"),
          const Divider(color: Colors.black26),
          infoRow(Icons.ac_unit, "Min Temp",
              "${weather?.tempMin?.celsius?.toStringAsFixed(1)} °C"),
          const Divider(color: Colors.black26),
          infoRow(Icons.air, "Wind",
              "${weather?.windSpeed?.toStringAsFixed(1)} km/h"),
          const Divider(color: Colors.black26),
          infoRow(Icons.water_drop, "Humidity",
              "${weather?.humidity?.toStringAsFixed(1)} %"),
        ],
      ),
    );
  }

  Widget infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF607D8B), size: 24),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style:
                      const TextStyle(color: Color(0xFF607D8B), fontSize: 16))),
          Text(value,
              style: const TextStyle(color: Color(0xFF263238), fontSize: 16)),
        ],
      ),
    );
  }
}
