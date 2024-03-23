import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  int sunset = 0;
  int sunrise = 0;
  double tempMax = 0;
  double tempMin  = 0;

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
      sunrise = weatherData['sys']['sunrise'];
      sunset = weatherData['sys']['sunset'];
      tempMax = weatherData['main']['temp_max'];
      tempMin = weatherData['main']['temp_min'];
    });
  }
/// for time
  String _formatTime(DateTime dateTime) {
    String period = dateTime.hour >= 12 ? 'PM' : 'AM';
    int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    hour = hour == 0 ? 12 : hour;
    String minute = dateTime.minute < 10 ? '0${dateTime.minute}' : '${dateTime.minute}';
    return '$hour:$minute $period';
  }
  ///for date
  String _formatDate(DateTime dateTime) {
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    return '$year-$month-$day';
  }

  getCurrentLocationWeather() async {
    var weatherData = await weather.getLocationWeather();

    updateUI(weatherData);
  }

  getWeatherBySearch() async {
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
                      onPressed: getCurrentLocationWeather,
                      child: kLocationIcon,
                    ),
                    TextButton(
                      onPressed: getWeatherBySearch,
                      child: kCityIcon,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: kRight15Pad,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 15,),
                    Column(
                      children: [
                        Text('$temperature°',
                            style: GoogleFonts.actor(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("Precipitations",
                        style: GoogleFonts.poppins(
                          fontSize:26,
                        ),
                        ),
                        Row(
                          children: [
                            Text('Max °: ${tempMax.roundToDouble().toString()}',style: GoogleFonts.poppins(
                              fontSize:16,
                            ),),
                            SizedBox(width: 20,),
                            Text('Min °: ${tempMin.roundToDouble().toString()}',style: GoogleFonts.poppins(
                              fontSize:16,
                            ),),
                          ],
                        ),


                      ],
                    ), Text(
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
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(25),
                      width: 200,
                      height: 190,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("Sunrise",style: TextStyle(fontSize: 20),),
                                    Spacer(),
                                    Icon(Icons.sunny,color: Colors.yellow,),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Text('${_formatTime(DateTime.fromMillisecondsSinceEpoch(sunrise * 1000))}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text('${_formatDate(DateTime.fromMillisecondsSinceEpoch(sunrise * 1000))}',
                                  style: TextStyle(fontSize: 16),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(25),
                      width: 200,
                      height: 190,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("Sunset",style: TextStyle(fontSize: 20),),
                                    Spacer(),
                                    Icon(Icons.nightlight,),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Text('${_formatTime(DateTime.fromMillisecondsSinceEpoch(sunset * 1000))}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text('${_formatDate(DateTime.fromMillisecondsSinceEpoch(sunrise * 1000))}',
                                  style: TextStyle(fontSize: 16),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

//Constant Files......
const kRight15Pad = EdgeInsets.only(right: 15.0,left: 5);

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
