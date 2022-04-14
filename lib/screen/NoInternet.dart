import 'dart:async';
import 'dart:io';

import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/screen/AddUserVehicle.dart';
import 'package:bike_service_app/screen/HomePage.dart';
import 'package:bike_service_app/screen/bookingStatus.dart';
import 'package:bike_service_app/screen/splashscreen.dart';
import 'package:bike_service_app/screen/addVehicleStatus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart'as http;


class NoInternet extends StatefulWidget {
  const NoInternet({ Key? key }) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {


  checkInternet() async {
    int timeout = 5;
    try {
      http.Response response = await http.get(Uri.parse('https://www.google.co.in')).
      timeout(Duration(seconds: timeout));
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) =>SplashScreen()), (route) => false);
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => SplashScreen()));
      } else {
        snackBarPopup();
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      snackBarPopup();
    } on SocketException catch (e) {
      print('Socket Error: $e');
      snackBarPopup();
    } on Error catch (e) {
      print('General Error: $e');
      snackBarPopup();
    }
  }

  snackBarPopup() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
            content: Text("No Internet. Please try Again",
             style: TextStyle(fontFamily: 'Poppins', ),
             ),
             behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 69.h,
        right: 20,
        left: 20),
             ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        //  appBar: AppBar(
        //    backgroundColor: kPrimaryColor,
        //    title: Text('Network Error'),
        //  ),
        body: Center(
          child: Container(
            
            child: Column(
              children: [
                SizedBox(height: 10.h,
                ),
                Container(
                  width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        
                    ),
                    child: Lottie.asset('assets/no_internet.json',)),
                SizedBox(height: 10.h,),
                Text('No Internet Connection', style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),),

                SizedBox(height: 1.h,),
                Text('Please check your internet connection', style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),),
                SizedBox(height: 7.h,),
                GestureDetector(
                  onTap: (){
                      checkInternet();
                  },
                  child: Container(
                    height: 40, width: 170,
                    decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text("Try again", style: TextStyle(color: kPrimaryColor,
                          fontWeight: FontWeight.w500,

                          fontSize: 16,
                          fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}