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
    wf.currentWeatherByCityName("kolkata").then((weatherData) {
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
          SizedBox(height: 32),
          dateTimeInfo(),
          SizedBox(height: 20),
          WeatherIcon(),
          SizedBox(height: 20),
          currentTemp(),
          SizedBox(height: 20),
          extractInfo(),
        ],
      ),
    );
  }

  Widget locationHeader() {
    return Text(weather?.areaName ?? "",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ));
  }

  Widget dateTimeInfo() {
    DateTime now = weather!.date!;
    return Column(
      children: [
        Text(DateFormat("h:mm a").format(now),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat("EEEE").format(now),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(width: 8),
            Text("${DateFormat("d.m.y").format(now)}",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ],
    );
  }

  Widget WeatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        // Space below the icon
        Text(
          "${weather?.weatherDescription ?? ''}",
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget currentTemp() {
    return Text("${weather?.temperature?.celsius?.toStringAsFixed(0)} °C",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 90,
          fontWeight: FontWeight.w400,
        ));
  }

  Widget extractInfo() {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.15,
        width: MediaQuery.sizeOf(context).height * 0.80,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(
          2.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Max: ${weather?.tempMax?.celsius?.toStringAsFixed(0)} °C",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  "Min: ${weather?.tempMin?.celsius?.toStringAsFixed(0)} °C",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Wind: ${weather?.windSpeed?.toStringAsFixed(0)} km/h",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "Humidity: ${weather?.humidity?.toStringAsFixed(0)} %",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
