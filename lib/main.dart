import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_project/screens/loading_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gotoNextRout();
  }
 Timer gotoNextRout(){
    Timer timer= Timer(Duration(seconds: 2), () =>
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoadingScreen()))
    );
    return timer;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(
              gradient:
          LinearGradient(colors: [            Color(0xFF362A84),Color(0xFF805BCA),Color(0xFF8180F3),Color(0xFF8183F7)
          ],begin: Alignment.topCenter,end: Alignment.bottomCenter)
            ),

          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset('images/clouds.png'),
            Text("Weather",style: GoogleFonts.poppins(fontWeight:FontWeight.bold,fontSize:64,),),
            Text('ForeCasts',style: GoogleFonts.poppins(fontWeight:FontWeight.w600,fontSize:64,color:Color(0xFFDDB130))),
          ],)
        ],
      ),
    );
  }
}
