import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bike_service_app/common/utilities.dart';
import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/constants/constants.dart';
import 'package:bike_service_app/screen/About_us.dart';
import 'package:bike_service_app/screen/Contact_us.dart';
import 'package:bike_service_app/screen/GetVehicleInfo.dart';
import 'package:bike_service_app/screen/NoInternet.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../DataModels/GetAboutDataModel.dart';
import '../common/ApiList.dart';
import 'GetProfile.dart';
import 'Login.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  _ProfilepageState createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  String? name;
  bool isLoading = true;

  String? shareContent;
  String? storeLocation;
  Box box = Hive.box("API_BOX");
  GlobalKey globalKey = GlobalKey();

  getName() async {
    name = await box.get(Constants.USER_NAME);
    shareContent = await box.get(Constants.APP_LINK);
    storeLocation = await box.get(Constants.STORE_LOCATION);

    setState(() {
      name = name;
      shareContent = shareContent;
      storeLocation = storeLocation;
      print(name);
    });
  }

  GetAboutDataModel _getAboutInfo = GetAboutDataModel();
  getAbout() async {
    var response = await http.get(
      Uri.parse(API.getAbout),
    );
    print("about : ${jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      setState(() {
        _getAboutInfo = GetAboutDataModel.fromJson(jsonDecode(response.body));
        isLoading = false;
      });
    } else {
      print(response.body);
    }
  }

  getData() async {
    isLoading == true
        ? showDialog(
            context: context,
            builder: (context) {
              return Container(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: kPrimaryColor,
                ),
              );
            })
        : await Utilities.openMapStr(storeLocation.toString());
  }

  // Future refresh() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await Future.delayed(Duration(seconds: 0));
  //   setState(() {
  //     isLoading = false;
  //      getName();
  //   getAbout();
  //   });
  // }

  bool isInternetAvailable = true;
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
                 
        //  snackBarPopup();
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
      // snackBarPopup();
    } on SocketException catch (e) {
      print('Socket Error: $e');
        
      setState(() {
       
        isInternetAvailable = false;
      });
      // snackBarPopup();
    } on Error catch (e) {
      print('General Error: $e');
         snackBarPopup();
      setState(() {
      
        isInternetAvailable = false;
      });
      // snackBarPopup();
    }
  }

  snackBarPopup() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("No Internet. Please try Again", 
            style: TextStyle(fontFamily: 'Poppins', ),),
             behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 30.h,
        right: 20,
        left: 20),
            ));
  }

  

  @override
  void initState() {
    getName();
    getAbout();
  checkInternet();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return isInternetAvailable == true ?
    Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: Center(
              child: Text(
            'Settings',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins'),
          )),
        ),
        body: isLoading == true
            ? Center(
              child: Column(
                children: [
                SizedBox(height: 30.h,),
                  SizedBox(
                        height: 20.h, width: 80.w,
                        child:  Lottie.asset('assets/bike_ride.json',)
                        // CircularProgressIndicator(
                        //   strokeWidth: 3,
                        //   color: kPrimaryColor,
                        // ),
                      ),
                     
                      Text('Loading.....', style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold
                        
                      ),)
                ],
              ),)
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 10.h,
                          width: double.infinity,
                          child: Row(children: [
                            SizedBox(
                                height: 50,
                                width: 70,
                                child: Image.asset('assets/icons/profile.png')),
                            Text(name != null ? 'Hi ' + name! : 'Loading...',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                    fontFamily: 'Poppins')),
                            SizedBox(
                              width: 4,
                            ),
                          ])),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      SizedBox(height: _height * 0.02),
                      GestureDetector(
                          onTap: () {
                            
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GetProfile()));
                           
                                   
                          },
                          child: ProfileContainer(
                            image: 'assets/icons/profile.png',
                            text: 'Profile',
                          )),
                      SizedBox(
                        height: 9,
                      ),
                      // GestureDetector(
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => GetVehicle()));
                      //     },
                      //     child: ProfileContainer(
                      //       image: 'assets/icons/vehiclee.png',
                      //       text: 'My Vehicle',
                      //     )),
                      // SizedBox(
                      //   height: 9,
                      // ),
                      GestureDetector(
                          onTap: () async {
                            await Utilities.openMapStr(
                                _getAboutInfo.storeLocation.toString()) ;
                           
                            // Utilities.openMapStr(storeLocation.toString());
                          },
                          child: Container(
                            color: Colors.grey[100],
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Image.asset('assets/icons/map.png')),
                                SizedBox(
                                  width: 16,
                                ),
                                //  isLoading == true ?

                                Text(
                                  'Store Locator',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins'),
                                )

                                //  : CircularProgressIndicator()
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 9,
                      ),
                      GestureDetector(
                          onTap: () async {
                            await Share.share(_getAboutInfo.shareAppLinkContent.toString());
                          },
                          child: ProfileContainer(
                            image: 'assets/icons/share.png',
                            text: 'Share App',
                          )),
                      SizedBox(
                        height: 9,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactUs()));
                          },
                          child: ProfileContainer(
                            image: 'assets/icons/contactus.png',
                            text: 'Contact us',
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutUs()));
                          },
                          child: ProfileContainer(
                            image: 'assets/icons/aboutus.png',
                            text: 'About us',
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            _logOut();
                          },
                          child: ProfileContainer(
                            image: 'assets/icons/logout.png',
                            text: 'Logout',
                          )),
                    ],
                  ),
                ),
              ))

    :  NoInternet();
    // Scaffold(   
    //          backgroundColor: kPrimaryColor,
    //     //  appBar: AppBar(
    //     //    backgroundColor: kPrimaryColor,
    //     //    title: Text('Network Error'),
    //     //  ),
    //     body: Center(
    //       child: Container(           
    //         child: Column(
    //           children: [
    //             SizedBox(height: 9.h,
    //             ),
    //             Container(
    //               width: double.infinity,
    //                 decoration: BoxDecoration(
    //                     color: Colors.white,                     
    //                 ),
    //                 child: Lottie.asset('assets/no_internet.json',)),
    //             SizedBox(height: 4.h,),
    //             Text('No Internet Connection', style: TextStyle(
    //                 fontFamily: "Poppins",
    //                 color: Colors.white,
    //                 fontSize: 18,
    //                 fontWeight: FontWeight.w600),),
    //             SizedBox(height: 1.h,),
    //             Text('Please check your internet connection', style: TextStyle(
    //                 fontFamily: "Poppins",
    //                 color: Colors.white,
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.w400),),
    //             SizedBox(height: 5.h,),
    //             GestureDetector(
    //               onTap: (){
    //                   checkInternet();
    //                   print('ugjhj');
    //               },
    //               child: Container(
    //                 height: 40, width: 170,
    //                 decoration: BoxDecoration(
    //                     border: Border.all(color: kPrimaryColor),
    //                     color: Colors.white,
    //                     borderRadius: BorderRadius.circular(20)),
    //                 child: Center(
    //                   child: Text("Try again", style: TextStyle(color: kPrimaryColor,
    //                       fontWeight: FontWeight.w500,
    //                       fontSize: 16,
    //                       fontFamily: 'Poppins'),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     )
    
    // );
 
  }

  Future _logOut() async {
    await box.clear();
    await FirebaseAuth.instance.signOut();

    print('hhfghghgvghghgh'); // testing
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
}

class ProfileContainer extends StatelessWidget {
  final String image;
  final String text;

  const ProfileContainer({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(height: 25, width: 25, child: Image.asset(image)),
          SizedBox(
            width: 16,
          ),
          Text(
            text,
            style:
                TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
          )
        ],
      ),
    );
  }
}
