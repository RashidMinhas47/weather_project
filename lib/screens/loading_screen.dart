import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_project/screens/location_screen.dart';
import 'package:weather_project/services/weather_model.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getLocationData(context);
  }

  void getLocationData(context) async {
    var weatherData = await WeatherModel().getLocationWeather();
    if (weatherData != null) {
      setState(() {
        isLoading = false;
      });
    }
    print(weatherData);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LocationScreen(
                  locationWeather: weatherData,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
