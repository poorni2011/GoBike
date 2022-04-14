import 'dart:async';
import 'dart:convert';

import 'package:bike_service_app/screen/AddUserVehicle.dart';
import 'package:bike_service_app/screen/NoInternet.dart';
import 'package:bike_service_app/screen/bookingStatus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:bike_service_app/DataModels/get_cities_data_model.dart';
import 'package:bike_service_app/common/ApiList.dart';
import 'package:bike_service_app/common/utilities.dart';
import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/constants/constants.dart';
import 'package:bike_service_app/screen/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../DataModels/GetAboutDataModel.dart';
import 'Login.dart';
import 'Registerpage.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation? animation, delayedAnimation, muchDelayedAnimation;
  AnimationController? animationController;
  bool isLoading = true;
  Box box = Hive.box("API_BOX");
  bool isDataLoading = true;
  StreamSubscription? sub;
  bool? hasInternet = false;

// final NetworkManager _networkManager = Get.find<NetworkManager>();

  @override
  void initState() {
    startTimer();
    getCities();
    getAbout();

    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController!, curve: Curves.fastOutSlowIn));
    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn)));
    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
              backgroundColor: kPrimaryColor,
              body: SafeArea(
                child: Center(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Transform(
                          transform: Matrix4.translationValues(
                              animation!.value * width, 0.0, 0.0),
                          child: SizedBox(
                              height: 30.h,
                              width: 45.w,
                              child: Image.asset(
                                'assets/images/logoo.png',
                                fit: BoxFit.cover,
                              )),
                        ),
                        Transform(
                          transform: Matrix4.translationValues(
                              animation!.value * width, 0.0, 0.0),
                          child: Text(
                            'GoBike Home',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                        ),

                        SizedBox(
                          height: 20.h,
                        ),
                        Transform(
                          transform: Matrix4.translationValues(
                              delayedAnimation!.value * width, 0.0, 0.0),
                          child: SizedBox(
                              height: 20.h,
                              width: 50.w,
                              child: Lottie.asset('assets/bike_ride.json',
                                  fit: BoxFit.cover)
                              // CircularProgressIndicator(
                              //   strokeWidth: 3,
                              //   color: kPrimaryColor,
                              // ),
                              ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        // SizedBox(
                        //   height: 20, width:20,
                        //   child: CircularProgressIndicator(
                        //     strokeWidth: 4,
                        //     color: Colors.white
                        //   ),
                        // ),

                        Transform(
                          transform: Matrix4.translationValues(
                              muchDelayedAnimation!.value * width, 0.0, 0.0),
                          child: Text(
                            'Feel The Ride',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )

                        // SizedBox(height: 10.h,),
                        //             SizedBox(
                        //       height: 40.h,
                        //       width: width,
                        //       child: Image.asset(
                        //         'assets/go_bike.gif',
                        //         fit: BoxFit.fill,
                        //       ),
                        //     ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  GetAboutDataModel _getAboutInfo = GetAboutDataModel();
  getAbout() async {
    var client = http.Client();
    try {
      var response = await http.get(
        Uri.parse(API.getAbout),
      );
      var data = jsonDecode(response.body);

      print("about : $data");

      if (response.statusCode == 200) {
        setState(() {
          _getAboutInfo = GetAboutDataModel.fromJson(jsonDecode(response.body));
          isDataLoading = false;
        });

        // Utilities.setPreference(Constants.APP_NAME, _getAboutInfo.appName.toString());
        // Utilities.setPreference(Constants.ABOUT_US_CONTENT, _getAboutInfo.aboutUsContent.toString());
        // Utilities.setPreference(Constants.APP_CONTACT_NUMBER, _getAboutInfo.contactNumber.toString());
        // Utilities.setPreference(Constants.EMAIL, _getAboutInfo.email.toString());
        // Utilities.setPreference(Constants.WEBSITE, _getAboutInfo.website.toString());
        // Utilities.setPreference(Constants.SERVICE_NUMBER, _getAboutInfo.serviceNumber.toString());
        // Utilities.setPreference(Constants.ACTIVE_STATUS, _getAboutInfo.activeStatus.toString());
        // Utilities.setPreference(Constants.BOOKING_ENABLE, _getAboutInfo.bookingEnble.toString());
        // Utilities.setPreference(Constants.SHOP_ADDRESS, _getAboutInfo.address.toString());
        // Utilities.setPreference(Constants.STORE_LOCATION, _getAboutInfo.storeLocation.toString());
        // Utilities.setPreference(Constants.APP_LINK, _getAboutInfo.shareAppLinkContent.toString());
        // Utilities.setPreference(Constants.IS_FIRST_MSG, _getAboutInfo.isFirstMsg.toString());
        box.put(Constants.APP_NAME, _getAboutInfo.appName.toString());
        box.put(Constants.ABOUT_US_CONTENT,
            _getAboutInfo.aboutUsContent.toString());
        box.put(Constants.APP_CONTACT_NUMBER,
            _getAboutInfo.contactNumber.toString());
        box.put(Constants.EMAIL, _getAboutInfo.email.toString());
        box.put(Constants.WEBSITE, _getAboutInfo.website.toString());
        box.put(
            Constants.SERVICE_NUMBER, _getAboutInfo.serviceNumber.toString());
        box.put(Constants.ACTIVE_STATUS, _getAboutInfo.activeStatus.toString());
        box.put(
            Constants.BOOKING_ENABLE, _getAboutInfo.bookingEnble.toString());
        box.put(Constants.SHOP_ADDRESS, _getAboutInfo.address.toString());
        box.put(
            Constants.STORE_LOCATION, _getAboutInfo.storeLocation.toString());
        box.put(
            Constants.APP_LINK, _getAboutInfo.shareAppLinkContent.toString());
        box.put(Constants.IS_FIRST_MSG, _getAboutInfo.isFirstMsg.toString());
      } else {
        print(response.body);
      }
    } on Exception catch (e) {
      print('getAbout : $e');
      client.close();
    }
  }

  void startTimer() {
    Timer(Duration(seconds: 4), () {
      navigateUser();
    });
  }

  void navigateUser() async {
  

    var loginStatus = await box.get(Constants.USER_LOGIN_STATUS);
    print('status $loginStatus');

    if (loginStatus == Constants.LOGGED_IN) {
    //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Bookingstatus(
    //    text: Column(
    //      children: [
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 23),
    //           child: Text(
    //                     ' Thanks for choosing GoBike Home. Applied promo code for your first order. You will pay less 99 from the total service amount.',
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                         fontWeight: FontWeight.w800,
    //                         color: Colors.red,
    //                         fontSize: 14.sp,
    //                         fontFamily: 'Poppins'),
    //                   ),
    //         ),
    //                 SizedBox(
    //                   height: 20,
    //                 ),
    //        Text('Booking added successfully',
    //         style: TextStyle(
    //           fontFamily: 'Poppins',
    //           fontWeight: FontWeight.w500,
    //           fontSize: 14.sp
    //         ),
    //         ),
    //      ],
    //    ))), (route) => false);

      // showDialog(
      //     barrierDismissible: false,
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
           
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.all(Radius.circular(32.0))),
      //         title: Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 7),
      //           child: Lottie.asset(
      //             'assets/tick.json',
      //             repeat: false,
      //             height: 30.h,
      //             width: 30.w,
      //           ),
      //         ),
      //         content: SingleChildScrollView(
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [             
      //               Text(
      //                 ' Thanks for choosing GoBike Home. Applied promo code for your first order. You will pay less 99 from the total service amount.',
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(
      //                     fontWeight: FontWeight.bold,
      //                     color: Colors.green,
      //                     fontSize: 14.sp,
      //                     fontFamily: 'Chakra Petch',
      //                     ),
      //                     ),
                  
      //               SizedBox(
      //                 height: 20,
      //               ),
      //               Text('Booking added successfully',
      //               textAlign: TextAlign.center,
      //                   style: TextStyle(
      //                      fontSize: 14.sp,
      //                      color: Colors.white,
      //                     fontWeight: FontWeight.w800,
      //                     fontFamily: 'Chakra Petch',
      //                   )),
      //             ],
      //           ),
      //         ),
      //         actions: [
      //           Center(
      //             child: ElevatedButton(
      //               style: 
      //               ButtonStyle(
      //                  backgroundColor: MaterialStateProperty.all(Colors.white),
      //                   shape:
      //                       MaterialStateProperty.all<RoundedRectangleBorder>(
      //                           RoundedRectangleBorder(
      //                               borderRadius: BorderRadius.circular(20.0),
      //                               ))),
      //               child: Padding(
      //                 padding: const EdgeInsets.all(10.0),
      //                 child: Text(
      //                   'Done',
      //                   style: TextStyle(
      //                     fontFamily: 'Poppins',
      //                     color: kPrimaryColor
      //                     ),
      //                 ),
      //               ),
      //               onPressed: () {
      //                 //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainPage()));
      //                 Navigator.pushAndRemoveUntil(
      //                     context,
      //                     MaterialPageRoute(builder: (context) => MainPage()),
      //                     (route) => false);
      //               },
      //             ),
      //           ),
      //          SizedBox(height: 2.h,)
      //         ],
      //       );
      //     });

      

       Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => MainPage()));
    } else {
      print('jhxjj4');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));

    }
    
  }

  //  print(status);
  //   if (status == Constants.LOGGED_IN) {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
  //   }
  //   else {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginpage()));
  //   }

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // var status = prefs.getBool('isLoggedIn') ?? false;
  // print(status);
  // if (status) {
  //   Navigation.pushReplacement(context, "/Home");
  // } else {
  //   Navigation.pushReplacement(context, "/Login");
  // }

  List<GetCitiesDataModel> _getCities = <GetCitiesDataModel>[];
  getCities() async {
    var client = http.Client();
    try {
      var url = Uri.parse(API.getCities);

      var response = await http.get(url);

      var cities = jsonDecode(response.body);
      print(cities);

      if (response.statusCode == 200) {
        setState(() {
          _getCities = jsonDecode(response.body)
              .map<GetCitiesDataModel>(
                  (_item) => GetCitiesDataModel.fromJson(_item))
              .toList();

          box.put(Constants.CITY_NAME, _getCities[0].name);
         
        
        });
          box.put(Constants.DEFAULT_CITY, _getCities.first.name.toString());
         print('default city : ${box.get(Constants.DEFAULT_CITY)}');
      } else {
        Utilities.showToast(context, response.body);
      }
    } on Exception catch (e) {
      print(e);
      client.close();
    }
  }
  //  String? cityName;
  // getInfo(){
  //    cityName = Utilities.setPreference(Constants.CITY_NAME, _getCities.single.name.toString());
  //    setState(() {
  //      cityName = cityName;
  //    });
  // }

}
