import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bike_service_app/DataModels/check_user.dart';
import 'package:bike_service_app/DataModels/check_user_data_model.dart';
import 'package:bike_service_app/DataModels/get_user_vehicle.dart';
import 'package:bike_service_app/common/ApiList.dart';
import 'package:bike_service_app/common/utilities.dart';
import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/constants/constants.dart';
import 'package:bike_service_app/screen/AddUserVehicle.dart';
import 'package:bike_service_app/screen/Registerpage.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'MainPage.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FROM_STATE,
  SHOW_OTP_FROM_STATE,
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FROM_STATE;

  String? phoneNo;
  String? myverificationId;
  bool? isLoading;

  set verificationId(String? verificationId) {}
// bool codeSent = false;

  Box box = Hive.box("API_BOX");

  final _formKey = GlobalKey<FormState>();

  TextEditingController mobileController = TextEditingController();
  TextEditingController _otp = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  

  FocusNode myFocusNode = new FocusNode();

  getMobileFormWidget(context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 7.w,
                    right: 7.w,
                    top: 15.h,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            // offset: Offset(, 1),
                            blurStyle: BlurStyle.outer,
                            blurRadius: 4.0,
                            spreadRadius: 0.3)
                      ]),
                  padding: EdgeInsets.symmetric(horizontal: 9.w),
                  height: 76.h,
                  width: _width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/logoo.png',
                            fit: BoxFit.cover,
                            height: 23.h,
                            width: 30.w,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          "Enter Your Mobile Number to Create account",
                          style:
                              TextStyle(fontFamily: "Poppins", fontSize: 13.sp),
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          onChanged: (phoneNumber) {
                            setState(() {
                              this.phoneNo = phoneNumber;
                            });
                          },
                          controller: mobileController,
                          //  autovalidate: true,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.black54,
                          validator: (mobile) {
                            String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                            RegExp regExp = new RegExp(pattern);
                            if (mobile!.isEmpty)
                              return 'Enter Your Mobile Number!';
                            else if (mobile.length >= 11)
                              return 'Enter 10 digit Number only';
                            else if (!regExp.hasMatch(mobile))
                              return 'Please Enter Valid Mobile Number';
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            hintText: 'Enter Mobile Number',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                      // Row(
                      //   children: [
                      //     CountryCodePicker(
                      //       initialSelection: 'IN',
                      //       showFlag: true,

                      //     ),

                      //   ],
                      // ),
                      // IntlPhoneField(

                      //   // validator: (mobile) {
                      //   //   String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                      //   //   RegExp regExp = new RegExp(pattern);
                      //   //   if (mobile!.isEmpty)
                      //   //     return 'Enter Your Mobile Number!';
                      //   //   else if (mobile.length >= 11)
                      //   //     return 'Enter 10 digit Number only';
                      //   //   else if (!regExp.hasMatch(mobile))
                      //   //     return 'Please Enter Valid Mobile Number';
                      //   //   return null;
                      //   // },

                      //   showDropdownIcon: false,
                      //   initialCountryCode: "IN",
                      //   decoration: InputDecoration(
                      //       hintText: "Mobile Number",
                      //       hintStyle: TextStyle(
                      //         fontFamily: 'Poppins',
                      //       )),
                      //   onChanged: (phoneNumber) {
                      //     setState(() {
                      //       this.phoneNo = phoneNumber.completeNumber;
                      //     });
                      //   },
                      // ),
                      SizedBox(
                        height: 7.h,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(kPrimaryColor)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              verifyPhone();
                            }
                          },
                          child: isLoading == true
                              ? SizedBox(
                                  height: 19,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.black,
                                  ))
                              : Text(
                                  'Send OTP',
                                  style: TextStyle(fontFamily: 'Poppins'),
                                )),

                      // getOtpFormWidget(context)
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  static List<GetVehicleDataModel> _getVehicle = <GetVehicleDataModel>[];
  Future vehicleInfoCheck() async {
    String token = await box.get(Constants.USER_TOKEN);
    print('user token :$token');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $token'
    };

    // Map mappedData = {
    //   ""
    // };

    final response =
        await http.get(Uri.parse(API.getUserVehicle), headers: headers);
    var info = jsonDecode(response.body);

    GetVehicleDataModel _getVehicle = GetVehicleDataModel.fromJson(info);
    if (_getVehicle.status == 1) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false);
      box.put(Constants.BRAND_NAME, _getVehicle.vehicle!.brandName);
      box.put(Constants.YEAR_OF_PURCHASE, _getVehicle.vehicle!.yearOfPurchase);
      box.put(Constants.PLATE_NO, _getVehicle.vehicle!.plateNo);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AddUserVehicle()),
          (route) => false);
    }
  }

  checkUser() async {
    var client = http.Client();

    try {
      Map mappeddata = {'phone': '+91$phoneNo'};

      print(mappeddata);

      final response =
          await http.post(Uri.parse(API.checkUser), body: mappeddata);

      final info = jsonDecode(response.body);
      print('jfgfg');
      print('User :$info');
      print('jfgfg2');

      CheckUserDataModel val = CheckUserDataModel.fromJson(info);
      CheckUser value = CheckUser.fromJson(info);

      if (val.status == 0) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Registerpage(
                      mobile: '+91$phoneNo',
                    )),
            (route) => false);

        print('hghh');
      } else {
        print('djshjhs');

        box.put(Constants.USER_LOGIN_STATUS, Constants.LOGGED_IN);

        box.put(Constants.USER_ID, value.data!.id.toString());
        box.put(Constants.USER_NAME, value.data!.name.toString());
        box.put(Constants.USER_EMAIL, value.data!.email.toString());
        box.put(Constants.USER_TOKEN, value.accessToken.toString());
        box.put(Constants.USER_TOKEN_TYPE, value.tokenType.toString());

        box.put(Constants.USER_REFERAL_CODE, value.tokenType.toString());

        //     var addVehicleInfo =
        // await Utilities.getPreference(Constants.ADDED_VEHICLE_INFO);
        // if(addVehicleInfo == Constants.INFO_ADDED){
        //   print('ghghg');
        //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MainPage()), (route) => false);
        // }else{
        //   print('ghghg11111');
        //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> AddUserVehicle()), (route) => false);
        // }
        vehicleInfoCheck();
      }
    } on Exception catch (e) {
      print(e);
      client.close();
    }
  }

  getOtpFormWidget(context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.only(
                left: 7.w,
                right: 7.w,
                top: 15.h,
              ),
              height: 76.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      // offset: Offset(, 1),
                      blurStyle: BlurStyle.outer,
                      blurRadius: 4.0,
                      spreadRadius: 0.3)
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                      height: 230,
                      width: 230,
                      child: Lottie.asset("assets/otp.json")),
                  Text(
                    "OTP Verification",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Enter the OTP Sent to Mobile",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 12.5.sp),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70),
                    child: TextFormField(
                      cursorColor: Colors.black54,
                      controller: _otp,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                          hintText: "Enter OTP",
                          hintStyle: TextStyle(fontFamily: 'Poppins')),
                    ),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                      ),
                      onPressed: () async {
                        verifyOtp();
                      },
                      child: isLoading == true
                          ? SizedBox(
                              height: 19,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.black,
                              ))
                          : Text(
                              'Verify',
                              style: TextStyle(fontFamily: 'Poppins'),
                            )),

                  // Row(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 40),
                  //       child: Text(
                  //         "Didn't You Receive the OTP?",
                  //         style: TextStyle(
                  //             fontFamily: "Poppins", fontSize: 12),
                  //       ),
                  //     ),
                  //     TextButton(
                  //         onPressed: () {
                  //           verifyPhone();
                  //         },
                  //         child: Text(
                  //           "Resend OTP",
                  //           style: TextStyle(
                  //               fontFamily: "Poppins", fontSize: 12),
                  //         ))
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            child:
                currentState == MobileVerificationState.SHOW_MOBILE_FROM_STATE
                    ? getMobileFormWidget(context)
                    : getOtpFormWidget(context)));

    // return
  }

  //  bool isInternetAvailable = true;
  // checkInternet() async {
  //   int timeout = 5;
  //   try {
  //     http.Response response = await http.get(Uri.parse('https://www.google.co.in')).
  //     timeout(Duration(seconds: timeout));
  //     if (response.statusCode == 200) {
  //          setState(() {
  //         isInternetAvailable = true; 
  //       });  
  //     } else {
                 
  //       //  snackBarPopup();
  //       // handle it
  //       setState(() { 
  //         isInternetAvailable = false;
  //       });
  //     }
  //   } on TimeoutException catch (e) {
  //     print('Timeout Error: $e'); 
  //     setState(() {
         
  //       isInternetAvailable = false;
  //     });
  //     // snackBarPopup();
  //   } on SocketException catch (e) {
  //     print('Socket Error: $e');
  
  //     setState(() {
       
  //       isInternetAvailable = false;
  //     });
  //     // snackBarPopup();
  //   } on Error catch (e) {
  //     print('General Error: $e');
  //       //  snackBarPopup();
  //     setState(() {
      
  //       isInternetAvailable = false;
  //     });
  //     // snackBarPopup();
  //   }
  // }

  // snackBarPopup() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text("No Internet. Please try Again", 
  //           style: TextStyle(fontFamily: 'Poppins', ),),
  //           behavior: SnackBarBehavior.floating,
  //           margin: EdgeInsets.only(
  //       bottom: MediaQuery.of(context).size.height - 20.h,
  //       right: 20,
  //       left: 20),
  //           ));
  // }

  verifyPhone() async {
    setState(() {
      isLoading = true;
    });
    box.put(Constants.PHONE_NO, '+91$phoneNo');

    await auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNo',
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {
          isLoading = false;
        });
        //signInWithPhoneAuthCredential(phoneAuthCredential);
      },
      verificationFailed: (verificationFailed) async {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Enter valid mobile number',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        )));
      },
      codeSent: (verificationId, resendingToken) async {
        setState(() {
          isLoading = false;
          currentState = MobileVerificationState.SHOW_OTP_FROM_STATE;
          this.myverificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  verifyOtp() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: myverificationId!, smsCode: _otp.text);

    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      isLoading = true;
    });

    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        isLoading = false;
      });

      if (authCredential.user != null) {
        checkUser();
        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Registerpage(mobile: phoneNo,)), (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      print('otp : $e');
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Enter valid OTP",
        style: TextStyle(
          fontFamily: 'Poppins',
        ),
      )));
    }
  }
}
