import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bike_service_app/DataModels/GetAboutDataModel.dart';
import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/screen/NoInternet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../common/ApiList.dart';
import '../common/utilities.dart';
import '../constants/constants.dart';

class  ContactUs extends StatefulWidget {

  const ContactUs({ Key? key }) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String? address;

  String? website;

  String? mobile;

  bool isLoading = true;
  Box box = Hive.box("API_BOX");

  getInfo() async {

    address = await box.get(Constants.SHOP_ADDRESS);
    website = await box.get(Constants.WEBSITE);
    mobile = await box.get(Constants.APP_CONTACT_NUMBER);

    setState(() {
      address = address;
      website = website;
      mobile =mobile;
      isLoading = true;
    }
    );

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
            style: TextStyle(fontFamily: 'Poppins', ),
            ),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 20.h,
        right: 20,
        left: 20),
            
            ));
  }

  

  GetAboutDataModel _getAboutInfo = GetAboutDataModel();
  getAbout()async{
    var response = await http.get(Uri.parse(API.getAbout),);
    print("about : ${jsonDecode(response.body)}");
    if(response.statusCode == 200){
      setState(() {
         
        _getAboutInfo =  GetAboutDataModel.fromJson(jsonDecode(response.body));
         isLoading = false;
      });
    }
    else{
      print(response.body);
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getInfo();
    getAbout();
    checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return isInternetAvailable == true ?
     Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Contact Us',
          style: TextStyle(fontWeight: FontWeight.w600, fontFamily: "Poppins"),
        ),
      ),
      body: isLoading == false ?
      Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          children: [
            SizedBox(height: 70,),
            Center(
              child: Container(
                child: Center(
                  child: Image.asset('assets/images/logoo.png',
                                  fit: BoxFit.cover,
                                  height: 25.h,  width: 30.w,),
                ),
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            SizedBox(height: 40,),
             Row(
              children: [

                SizedBox(
                  width: 40,
                ),
                 Icon(Icons.location_city, size: 19,),
                SizedBox(width: 6,),
                Text(
                  'Address',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 12.sp),
                ),
                SizedBox(
                  width: 40,
                ),
                Flexible(
                  child: Text(
                     _getAboutInfo.address.toString(),
                    maxLines: 2,
                    style: TextStyle(

                        fontWeight: FontWeight.w400, fontFamily: "Poppins",fontSize: 12.sp),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                Icon(Icons.phone, size: 19,),
                SizedBox(width: 6,),
                Text(
                  'Mobile',
                  style: TextStyle(

                      fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 12.sp),
                ),
                SizedBox(
                  width: 50,
                ),
                GestureDetector(
                  onTap: () {
                    launch("tel://${ _getAboutInfo.contactNumber.toString()}");
                  },
                  child: Text(
                   _getAboutInfo.contactNumber.toString(),
                    style: TextStyle(
                       color: kPrimaryColor,
                       decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w400, fontFamily: "Poppins", fontSize: 12.sp),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 40,
                ),
               Icon(Icons.web, size: 19,),
                SizedBox(width: 6,),
                Text(
                  'Website',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 12.sp),
                ),
                SizedBox(
                  width: 40,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: GestureDetector(
                    onTap: () {
                      launch("https://${_getAboutInfo.website.toString()}");
                    },
                    child: Text(
                   _getAboutInfo.website.toString(),
                         maxLines: 2,
                      style: TextStyle(
                            color: kPrimaryColor,
                       decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w400, fontFamily: "Poppins", fontSize: 12.sp),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
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
    ) :
    NoInternet();
  }
}