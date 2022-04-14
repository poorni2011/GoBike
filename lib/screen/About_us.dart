import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/screen/NoInternet.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../DataModels/GetAboutDataModel.dart';
import '../common/ApiList.dart';
import '../common/utilities.dart';
import '../constants/constants.dart';
import 'package:http/http.dart' as http;

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {


 Box box = Hive.box("API_BOX");
  String? address;
  String? website;
  String? mobile;
  String? content;
  bool isLoading = true;


  getInfo() async {

    address = await box.get(Constants.SHOP_ADDRESS);
    website = await box.get(Constants.WEBSITE);
    mobile = await box.get(Constants.APP_CONTACT_NUMBER);
    content = await box.get(Constants.ABOUT_US_CONTENT);
    

    setState(() {
      address = address;
      website = website;
      mobile =mobile;
      content = content;
      
    }
    );

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
  void initState() {
    // TODO: implement initState
    super.initState();
    getAbout();
    checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    return  isInternetAvailable == true ?
    Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.w600, fontFamily: "Poppins"),
        ),
      ),
      body: SingleChildScrollView(
        child:  isLoading == false ?
        Container(
          padding: EdgeInsets.all(9),
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
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
            SizedBox(
              height: 30,
            ),
         Container(
              child: Column(
                children: [
                        Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Text(
                  _getAboutInfo.aboutUsContent.toString(),
                style:
                    TextStyle(fontWeight: FontWeight.w400, fontFamily: "Poppins", fontSize: 12.sp),
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
                    maxLines: 3,
                    style: TextStyle(
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
                  onTap: (){
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
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      launch("https://${ _getAboutInfo.website.toString()}");
                    },
                    child: Text(
                      _getAboutInfo.website.toString(),
                      style: TextStyle(
                        color: kPrimaryColor,
                       decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w400, fontFamily: "Poppins",fontSize: 12.sp),
                    ),
                  ),
                ),
              ],
            )
          
                ],
              ),
            ),
         
          ]),
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
      ),
    ) :
    NoInternet();
  }
}
