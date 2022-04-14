import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bike_service_app/DataModels/get_booking_data_model.dart';
import 'package:bike_service_app/common/ApiList.dart';
import 'package:bike_service_app/common/utilities.dart';
import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/constants/constants.dart';
import 'package:bike_service_app/screen/NoInternet.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'MainPage.dart';

class Bookingpage extends StatefulWidget {
  const Bookingpage({Key? key}) : super(key: key);

  @override
  _BookingpageState createState() => _BookingpageState();
}

class _BookingpageState extends State<Bookingpage> {
  String? name;
  bool isLoading = true;
  

  List<GetBooKingDataModel> _getBooking = <GetBooKingDataModel>[];

  Box box = Hive.box("API_BOX");

  getDetails() async {
    var client = http.Client();

    String token = await box.get(Constants.USER_TOKEN);
    try {
      final headers = {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token'
      };
      var url = Uri.parse(API.getBooking);

      var response = await http.get(url, headers: headers);
      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        setState(() {
          _getBooking = jsonDecode(response.body)
              .map<GetBooKingDataModel>(
                  (_item) => GetBooKingDataModel.fromJson(_item))
              .toList();
        });
        if (_getBooking.isNotEmpty) {
          isLoading = false;
        } else {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    'No Booking',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MainPage()), (route) => false);
                        },
                        child: Text(
                          'Close',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ))
                  ],
                );
              });
        }
        // print('true');

      } else {
        print('false');
      }
    } on Exception catch (e) {
      print(e);
      client.close();
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
        bottom: MediaQuery.of(context).size.height - 30.h,
        right: 20,
        left: 20),
            ));
  }

  // Future refresh() async {
  //   setState(() {
  //     isLoading = true;
  //   });

   
  //   setState(() {
  //     isLoading = false;
  //     getDetails();
  //   });
  // }
  @override
  void initState() {
    getDetails();
    checkInternet();
    super.initState();
  }

 
    String formatTimestamp(String bookingTime) {
 DateTime date = DateTime.parse(bookingTime).toLocal();
return DateFormat('dd-MMM-yyy hh:mm aaa').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return isInternetAvailable == true?
    Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: Center(
              child: Text(
            'My Booking',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins'),
          )),
        ),
        body: !isLoading
            ? Column(
                children: [
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                            physics: ScrollPhysics(),
                            itemCount: _getBooking.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Card(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Stack(
                                        children: [
                                          Positioned(
                                            right: 4,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: kPrimaryColor,
                                                        width: 1.4)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                      '#' +
                                                          _getBooking[index]
                                                              .bookingNumber
                                                              .toString(),
                                                      style: new TextStyle(
                                                          fontSize: 11.0.sp,
                                                          color: Colors.black,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                )),
                                          ),
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 7),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                          height: 15,
                                                          width: 15,
                                                          child: Image.asset(
                                                              'assets/icons/name.png')),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                          _getBooking[index]
                                                              .customerName
                                                              .toString().toUpperCase(),
                                                          style: new TextStyle(

                                                              fontSize: 13.0.sp,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 7),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                          height: 15,
                                                          width: 15,
                                                          child: Image.asset(
                                                              'assets/icons/email.png')),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                          _getBooking[index]
                                                              .email
                                                              .toString(),
                                                          style: new TextStyle(
                                                              fontSize: 13.0.sp,
                                                              color: Colors
                                                                  .black87,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 7),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                          height: 15,
                                                          width: 15,
                                                          child: Image.asset(
                                                              'assets/icons/phone.png')),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                          _getBooking[index]
                                                              .phone
                                                              .toString(),
                                                          style: new TextStyle(
                                                              fontSize: 13.0.sp,
                                                              color: Colors
                                                                  .black87,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 7),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                          height: 18,
                                                          width: 18,
                                                          child: Image.asset(
                                                              'assets/icons/addresss.png')),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            _getBooking[
                                                                        index]
                                                                    .address
                                                                    .toString() +
                                                                ',' +
                                                                _getBooking[
                                                                        index]
                                                                    .pincode
                                                                    .toString() +
                                                                ',' +
                                                                _getBooking[
                                                                        index]
                                                                    .state
                                                                    .toString() +
                                                                ',' +
                                                                _getBooking[
                                                                        index]
                                                                    .city
                                                                    .toString(),
                                                            style: new TextStyle(
                                                                fontSize: 13.0.sp,
                                                                color: Colors
                                                                    .black87,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 7),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                          height: 15,
                                                          width: 15,
                                                          child: Image.asset(
                                                              'assets/icons/date.png')),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                        formatTimestamp(_getBooking[index]
                                                              .createdAt
                                                              .toString()),
                                                         
                                                          style: new TextStyle(
                                                              fontSize: 13.0.sp,
                                                              color: Colors
                                                                  .black87,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 290, bottom: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Complaints',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                             
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                    content: Text(
                                                      _getBooking[index]
                                                          .complaintDetails
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Back',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'Poppins'),
                                                          ))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Container(
                                           
                                              height: 25,
                                              width: 25,
                                              child: Image.asset(
                                                  'assets/icons/complaint.png')),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })),
                  ),
                ],
              )
            : Center(
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
            )
          : NoInternet();
    //   : Scaffold(
      
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
}
