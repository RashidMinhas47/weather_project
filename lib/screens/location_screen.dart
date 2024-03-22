import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_project/screens/city_screen.dart';
import 'package:weather_project/utils/constants.dart';
import '../services/weather_model.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, this.locationWeather});

  final dynamic locationWeather;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  int temperature = 0;

  String weatherIcon = '0';

  String cityName = '0';

  String weatherMessage = '0';

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
      cityName = weatherData['name'];
    });
  }

  getCurrentLocationWeahter() async {
    var weatherData = await weather.getLocationWeather();

    updateUI(weatherData);
  }

  getWeatherBySearh() async {
    var typedName = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const CityScreen();
        },
      ),
    );
    if (typedName != null) {
      var weatherData = await weather.getCityWeather(typedName);
      updateUI(weatherData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            filterQuality: FilterQuality.low,
            image: const AssetImage(
              'images/bg_location_1.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: kPadd10,
                padding: kPadd10,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: getCurrentLocationWeahter,
                      child: kLocationIcon,
                    ),
                    TextButton(
                      onPressed: getWeatherBySearh,
                      child: kCityIcon,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: kRight15Pad,
                child: Row(
                  children: <Widget>[
                    Text('$temperature°',
                        style: GoogleFonts.actor(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: kRight15Pad,
                child: Text(
                  '$weatherMessage in $cityName',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                    fontSize: 49,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Constant Files......
const kRight15Pad = EdgeInsets.only(right: 15.0);

const kPadd10 = EdgeInsets.all(10);

const kCityIcon = Icon(
  Icons.location_city_rounded,
  color: Colors.black54,
  size: 40.0,
);
const kLocationIcon = Icon(
  Icons.near_me_rounded,
  color: Colors.black54,
  size: 40.0,
);
