import 'dart:async';
import 'dart:io';

import 'package:bike_service_app/constants/colors_palette.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class Rewardspage extends StatefulWidget {
  const Rewardspage({Key? key}) : super(key: key);

  @override
  _RewardspageState createState() => _RewardspageState();
}

class _RewardspageState extends State<Rewardspage> {

  bool isLoading = true;
    bool isInternetAvailable = true;
  checkInternet() async {
    int timeout = 5;
    try {
      http.Response response = await http.get(Uri.parse('https://www.google.co.in')).
      timeout(Duration(seconds: timeout));
      if (response.statusCode == 200) {
         
        setState(() {
         
          isInternetAvailable = true;
           refresh();
        });
        
      } else {
                 
         snackBarPopup();
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
      snackBarPopup();
    } on SocketException catch (e) {
      print('Socket Error: $e');
        
      setState(() {
       
        isInternetAvailable = false;
      });
      snackBarPopup();
    } on Error catch (e) {
      print('General Error: $e');
         snackBarPopup();
      setState(() {
      
        isInternetAvailable = false;
      });
      snackBarPopup();
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

  Future refresh() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 0));
    setState(() {
      isLoading = false;
     checkInternet();
    });
  }
  
   @override
  void initState() {
    checkInternet();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return isInternetAvailable == true ?
    Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: Center(
              child: Text(
            'Refer and Earn',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
          )),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(6),
            child: Column(
              children: [
                Container(
                
                  height: 250,
                  child: Image.asset(
                    'assets/images/refer.png',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Tell Your Friends about FreeChange',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                  child: Text(
                      'Invite your friends to recharge on FreeCharge using your promocode and you both earn Rs.50',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontFamily: 'Poppins')),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: kPrimaryColor,
                  ),
                  
                  child: TextButton(
                      onPressed: () {
                        Share.share(
                            'https://play.google.com/store/apps/details?id=com.instructivetech.testapp');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Share',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ))

  : Scaffold(
      
             backgroundColor: kPrimaryColor,
        //  appBar: AppBar(
        //    backgroundColor: kPrimaryColor,
        //    title: Text('Network Error'),
        //  ),
        body: Center(
          child: Container(
            
            child: Column(
              children: [
                SizedBox(height: 9.h,
                ),
                Container(
                  width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        
                    ),
                    child: Lottie.asset('assets/no_internet.json',)),
                SizedBox(height: 4.h,),
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
                SizedBox(height: 5.h,),
                GestureDetector(
                  onTap: (){
                      checkInternet();
                      print('ugjhj');
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
