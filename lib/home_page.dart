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
  @override
  void initState() {
    super.initState();
    wf.currentWeatherByCityName("Dehradun").then((weatherData) {
      setState(() {
        weather = weatherData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildWeatherUI(),
    );
  }

  Widget buildWeatherUI() {
    if (weather == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          locationHeader(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
          ),
          dateTimeInfo(),
        ],
      ),
    );
  }

  Widget locationHeader() {
    return Text(weather?.areaName ?? "",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ));
  }

  Widget dateTimeInfo() {
    DateTime now = weather!.date!;
    return Column(
          children: [
            Text(
              DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
          )
          ),
          const SizedBox(
          height: 10,
        ),],
        
    );
  }
}
