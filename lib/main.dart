
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/screen/AddUserVehicle.dart';
import 'package:bike_service_app/screen/ComingSoonPage.dart';
import 'package:bike_service_app/screen/HomePage.dart';
import 'package:bike_service_app/screen/Login.dart';
import 'package:bike_service_app/screen/MainPage.dart';
import 'package:bike_service_app/screen/NoInternet.dart';
import 'package:bike_service_app/screen/Registerpage.dart';
import 'package:bike_service_app/screen/bookingStatus.dart';
import 'package:bike_service_app/screen/loginScreen.dart';
import 'package:bike_service_app/screen/splashscreen.dart';
import 'package:bike_service_app/screen/addVehicleStatus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'DataModels/get_cities_data_model.dart';
import 'common/ApiList.dart';
import 'common/utilities.dart';
import 'constants/constants.dart';
import 'package:http/http.dart'as http;
import 'package:sizer/sizer.dart';


void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   await Hive.initFlutter();
   await Hive.openBox('API_BOX');
 runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isInternetAvailable = true;

  @override
  void initState() {
    super.initState();
    checkInternet();

  }

 

  checkInternet() async {
    int timeout = 5;
    try {
      http.Response response = await http.get(Uri.parse('https://www.google.co.in')).
      timeout(Duration(seconds: timeout));
      if (response.statusCode == 200) {

        setState(() {
          isInternetAvailable = true;
        });
      } else {
        // handle it
        setState(() {
          isInternetAvailable = false;
        });
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      setState(() {
        isInternetAvailable = false;
      });
    } on SocketException catch (e) {
      print('Socket Error: $e');
      setState(() {
        isInternetAvailable = false;
      });
    } on Error catch (e) {
      print('General Error: $e');
      setState(() {
        isInternetAvailable = false;
      });
    }
  }


 @override
 void dispose() {
   
   super.dispose();
 }
  @override
  Widget build(BuildContext context) {
   return Sizer(
      builder: (context, orientation, deviceType) {
    return MaterialApp(
      // initialBinding: NetworkBinding(),
      home: isInternetAvailable ? SplashScreen(): NoInternet(),
      debugShowCheckedModeBanner: false,
    
      );
   
    }
   );
  }
  

    
  
}


