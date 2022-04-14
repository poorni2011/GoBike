import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bike_service_app/screen/Booking.dart';
import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/screen/NoInternet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../DataModels/GetSingleServiceDataModel.dart';
import '../common/ApiList.dart';
import '../common/utilities.dart';
import '../constants/constants.dart';
import 'package:http/http.dart' as http;

class DescrPage extends StatefulWidget {
  String? serviceid;

  DescrPage({
    this.serviceid,
  });

  @override
  _DescrPageState createState() => _DescrPageState();
}

class _DescrPageState extends State<DescrPage> {

 bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSingleService();
   checkInternet();
  }

  Box box = Hive.box("API_BOX");
  GetSingleServiceDataModel _getSingleService = GetSingleServiceDataModel();
  Future getSingleService() async {
    String token = await box.get(Constants.USER_TOKEN);

    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(
        Uri.parse(API.getSingleService + widget.serviceid!),
        headers: headers);
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      setState(() {
        _getSingleService =
            GetSingleServiceDataModel.fromJson(jsonDecode(response.body));
            isLoading = false;
      });
      
    } else {
      print(response.body);
    }
  }

   

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
        //  snackBarPopup();
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
        bottom: MediaQuery.of(context).size.height - 20.h,
        right: 20,
        left: 20),
            ));
  }
  

  @override
  Widget build(BuildContext context) {

    
   
    return isInternetAvailable == true ? 
    //  Scaffold(
    //         body: Container(
    //           child: Center(
    //           child: Column(
    //             children: [
    //              SizedBox(height: 40.h,),
    //               SizedBox(
    //                     height: 20.h, width: 80.w,
    //                     child:  Lottie.asset('assets/bike_ride.json',)
    //                     // CircularProgressIndicator(
    //                     //   strokeWidth: 3,
    //                     //   color: kPrimaryColor,
    //                     // ),
    //                   ),
                     
    //                   Text('Loading.....', style: TextStyle(
    //                     fontFamily: 'Poppins',
    //                     fontSize: 14.sp,
    //                     fontWeight: FontWeight.bold
                        
    //                   ),)
    //             ],
    //           ),)
    //         )
    //     //      Center(
    //     //   child: Container(
    //     //     color: kPrimaryColor,
    //     //     child: Column(
    //     //       children: [
    //     //         SizedBox(height: 9.h,
    //     //         ),
    //     //         Container(
    //     //           width: double.infinity,
    //     //             decoration: BoxDecoration(
    //     //                 color: Colors.white,                
    //     //             ),
    //     //             child: Lottie.asset('assets/no_internet.json',)),
    //     //         SizedBox(height: 4.h,),
    //     //         Text('No Internet Connection', style: TextStyle(
    //     //             fontFamily: "Poppins",
    //     //             color: Colors.white,
    //     //             fontSize: 18,
    //     //             fontWeight: FontWeight.w600),)
    //     //         SizedBox(height: 1.h,),
    //     //         Text('Please check your internet connection', style: TextStyle(
    //     //             fontFamily: "Poppins",
    //     //             color: Colors.white,
    //     //             fontSize: 16,
    //     //             fontWeight: FontWeight.w400),),
    //     //         SizedBox(height: 5.h,),
    //     //         GestureDetector(
    //     //           onTap: (){
    //     //               checkInternet();
    //     //               print('ugjhj');
    //     //           },
    //     //           child: Container(
    //     //             height: 40, width: 170,
    //     //             decoration: BoxDecoration(
    //     //                 border: Border.all(color: kPrimaryColor),
    //     //                 color: Colors.white,
    //     //                 borderRadius: BorderRadius.circular(20)),
    //     //             child: Center(
    //     //               child: Text("Try again", style: TextStyle(color: kPrimaryColor,
    //     //                   fontWeight: FontWeight.w500,
    //     //                   fontSize: 16,
    //     //                   fontFamily: 'Poppins'),
    //     //               ),
    //     //             ),
    //     //           ),
    //     //         ),
    //     //       ],
    //     //     ),
    //     //   ),
    //     // )
    //       )
      Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: isLoading == true ?

          Container(
              child: Center(
              child: Column(
                children: [
                 SizedBox(height: 40.h,),
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
            )
        //      Center(
        //   child: Container(
        //     color: kPrimaryColor,
        //     child: Column(
        //       children: [
        //         SizedBox(height: 9.h,
        //         ),
        //         Container(
        //           width: double.infinity,
        //             decoration: BoxDecoration(
        //                 color: Colors.white,                
        //             ),
        //             child: Lottie.asset('assets/no_internet.json',)),
        //         SizedBox(height: 4.h,),
        //         Text('No Internet Connection', style: TextStyle(
        //             fontFamily: "Poppins",
        //             color: Colors.white,
        //             fontSize: 18,
        //             fontWeight: FontWeight.w600),)
        //         SizedBox(height: 1.h,),
        //         Text('Please check your internet connection', style: TextStyle(
        //             fontFamily: "Poppins",
        //             color: Colors.white,
        //             fontSize: 16,
        //             fontWeight: FontWeight.w400),),
        //         SizedBox(height: 5.h,),
        //         GestureDetector(
        //           onTap: (){
        //               checkInternet();
        //               print('ugjhj');
        //           },
        //           child: Container(
        //             height: 40, width: 170,
        //             decoration: BoxDecoration(
        //                 border: Border.all(color: kPrimaryColor),
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(20)),
        //             child: Center(
        //               child: Text("Try again", style: TextStyle(color: kPrimaryColor,
        //                   fontWeight: FontWeight.w500,
        //                   fontSize: 16,
        //                   fontFamily: 'Poppins'),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // )

        : Container(    
            child: 
            Column(
              children: [
                Center(
                  child: FadeInImage(
                    height: 30.h,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      placeholder: AssetImage("assets/bannerLoading.gif"),
                      image: NetworkImage(
                        Constants.default_img +
                            _getSingleService.bannerImage.toString(),
                      ),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/bannerLoading.gif',
                            fit: BoxFit.fitWidth);
                      }),
                  // child: FadeInImage.assetNetwork(
                  //   image : Constants.default_img+_getSingleService.bannerImage.toString(),
                  //   placeholder: 'assets/images/logo.png',
                  //   width: double.infinity,
                  //   height: 200,
                  //   fit: BoxFit.fill,
                  // ),
                ),
                SizedBox(
                  height: 20,
                ),
              
                
                 Container(
                  child: Column(
                    children: [
                  Card(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, bottom: 20),
                        child: Container(
                          width: 200,
                          child: Text(
                            _getSingleService.name.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            _getSingleService.amount == 0 ?
                            Container()
                             :
                             Column(
                               children: [
                                 Text(
                                  'Rs ' + _getSingleService.strikeAmount.toString(),
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.red,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                            ),
                            Text(
                              'Rs ' + _getSingleService.amount.toString(),
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Poppins',
                              ),
                            ),
                               ],
                             ),
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(children: [
                  Container(
                    width: double.infinity,
                    height: 165,
                    color: Colors.white,
                    // child: Column(
                    //   children: [
                    //     //],
                    // ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          DescrContainerOne(
                              'assets/images/DesGoDigital.png',
                              'Go Digital',
                              'Convenient online payment options.'),
                          DescrContainerOne(
                              'assets/images/DesPickupDrop.png',
                              'Pick-Up & Drop',
                              'Service from the comfort of your home/office.')
                        ],
                      ),
                      Row(
                        children: [
                          DescrContainerOne('assets/images/DesOurPromise.png',
                              'Our Promise', '100% satisfaction guaranteed.'),
                          DescrContainerOne(
                              'assets/images/DesExpertService.png',
                              'Expert Service',
                              'Skilled mechanics for your every need.')
                        ],
                      )
                    ],
                  ),
                ]),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Salient Features',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _getSingleService.description.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: kTextColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Positioned(
                        //   bottom: 0.0,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => Booking(
                        //                     serviceId: widget.serviceid!,

                        //                   )));
                        //     },
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(left: 100),
                        //       child: Container(
                        //        padding: EdgeInsets.only(left: 35),
                        //         height: 45,
                        //         width: 150,
                        //         decoration: BoxDecoration(
                        //           color: kPrimaryColor,
                        //           borderRadius: BorderRadius.circular(30),
                        //         ),
                        //         child: Row(
                        //           children: [
                        //             Text(
                        //               'Booking',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontFamily: 'Poppins',
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.w800
                        //               ),
                        //             ),
                        //             Icon(Icons.arrow_forward, color: Colors.white, size: 19,)
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ]),
                ),
             
                    ],
                  ),
                )
               
              ],
            ),
          ) 
          
        ),
      ) ,
      // Center(
      //     child: Container(
      //       color: kPrimaryColor,
      //       child: Column(
      //         children: [
      //           SizedBox(height: 9.h,
      //           ),
      //           Container(
      //             width: double.infinity,
      //               decoration: BoxDecoration(
      //                   color: Colors.white,                   
      //               ),
      //               child: Lottie.asset('assets/no_internet.json',)),
      //           SizedBox(height: 4.h,),
      //           Text('No Internet Connection', style: TextStyle(
      //               fontFamily: "Poppins",
      //               color: Colors.white,
      //               fontSize: 18,
      //               fontWeight: FontWeight.w600),),
      //           SizedBox(height: 1.h,),
      //           Text('Please check your internet connection', style: TextStyle(
      //               fontFamily: "Poppins",
      //               color: Colors.white,
      //               fontSize: 16,
      //               fontWeight: FontWeight.w400),),
      //           SizedBox(height: 5.h,),
      //           GestureDetector(
      //             onTap: (){
      //                 checkInternet();
      //                 print('ugjhj');
      //             },
      //             child: Container(
      //               height: 40, width: 170,
      //               decoration: BoxDecoration(
      //                   border: Border.all(color: kPrimaryColor),
      //                   color: Colors.white,
      //                   borderRadius: BorderRadius.circular(20)),
      //               child: Center(
      //                 child: Text("Try again", style: TextStyle(color: kPrimaryColor,
      //                     fontWeight: FontWeight.w500,
      //                     fontSize: 16,
      //                     fontFamily: 'Poppins'),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      bottomNavigationBar: isLoading == true ?
      Container(
       height: 50,
      ) :
      Container(
        padding: EdgeInsets.all(5.0),
        height: 50,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Booking(
                          serviceId: widget.serviceid!,
                        )));
          },
          child: BottomAppBar(
            elevation: 0.0,
            color: kPrimaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Book Now",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 23,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    )

    : NoInternet();
 
  }
}

Widget DescrContainerOne(
  String iconPath,
  String title,
  String description,
) {
  return Flexible(
    child: Container(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 7, bottom: 25, right: 6),
            child: Container(
              height: 27,
              width: 27,
              child: Image.asset(iconPath),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 9,
              ),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                          fontSize: 17,
                          color: kTextColor,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        )),
                    SizedBox(
                        width: 130,
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: 12,
                            color: kTextColor,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget DescrContainerSec(String description) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Text(
      description,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: kTextColor,
      ),
    ),
  );
}

// 'assets/descrVehicleTowing.jpg' 'Vehicle Towing'


//  Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Card(
//                     child: Row(
//                       children: [
//                         Container(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 3),
//                             child: Row(
//                                  children: [
//                                         Padding(
//                                           padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
//                                           child: Container(
//                                             width: 200,
//                                             color: Colors.red,
//                                             child: Text(
//                                               widget.title!,
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 17,
//                                                 fontWeight: FontWeight.w700,
//                                                 fontFamily: 'Poppins',
//                                               ),
//                                             ),
//                                           ),
//                                         ),
                                       
                              
//                                  ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 6,),
//                         Flexible(
                            
//                                   child: Column(
                                   
//                                     children: [
//                                       Text(
                                        
//                                         'Rs ' + widget.strike_amount!,
                                        
//                                         style: TextStyle(
//                                           backgroundColor: Colors.blue,
//                                           decoration: TextDecoration.lineThrough,
//                                           color: Colors.red,
//                                           fontSize: 14,
                  
//                                           fontWeight: FontWeight.w500,
//                                           fontFamily: 'Poppins',
//                                         ),
//                                       ),
//                                       Text(
//                                           'Rs ' + widget.amount!,
//                                           style: TextStyle(
//                                             backgroundColor: Colors.yellow,
//                                           color: Colors.green,
//                                           fontSize: 19,
//                                           fontWeight: FontWeight.w500,
//                                           fontFamily: 'Poppins',
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                       ],
//                     ),
//                   ),
//                 ),
