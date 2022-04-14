import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart'as http;
import '../DataModels/BookingSuccessDataModel.dart';
import '../DataModels/GetAboutDataModel.dart';
import '../common/ApiList.dart';
import '../constants/colors_palette.dart';
import 'MainPage.dart';

class  Bookingstatus extends StatelessWidget {

   Widget text;
 Bookingstatus({ required this.text });

 

  // GetAboutDataModel _getAboutInfo = GetAboutDataModel();
  // getAbout()async{
  //   var response = await http.get(Uri.parse(API.getAbout),);
  //   print("about : ${jsonDecode(response.body)}");
  //   if(response.statusCode == 200){
  //     setState(() {
         
  //       _getAboutInfo =  GetAboutDataModel.fromJson(jsonDecode(response.body));
        
  //     });
  //   }
  //   else{
  //     print(response.body);
  //   }
  // }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              
              child: Column(
                children: [
                
                  // Text('Success', style: TextStyle(
                  //   color: kPrimaryColor,
                  //   fontFamily: 'Poppins',
                  //   fontSize: 28,
                  //   fontWeight: FontWeight.bold
                
                  // ),),
                  
                 SizedBox(
                   height: 9.h,
                 ),
                  Lottie.asset('assets/tick.json',
                  height: 40.h,
                  width: 100.w,
                  repeat: false
                   ),
                  SizedBox(height: 5.h,),
                text,
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25),
                  //   child: Text(
                  //   "Thanks for choosing GoBike Home. Applied promo code for your first order. You will pay less 99 from the total service amount.",
                  //   style: TextStyle(
                  //     fontSize: 14.sp,
                  //     fontWeight: FontWeight.w800,color: Colors.red, fontFamily: 'Poppins'),),
                  // ),
                  // SizedBox(height: 4.h,),
                  // Text('Booking added successfull',
                  // style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins'),),
                //  dataModel.isFirst == "true"?
                //          Text(
                //        _getAboutInfo.isFirstMsg.toString(),
                //          style: TextStyle(fontWeight: FontWeight.w800,color: Colors.red, fontFamily: 'Poppins'),
                //          ): Container(),
                //            SizedBox(height: 20,),
                //            Text(
                //              dataModel.message.toString(),
                //              style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                //            ),
                      SizedBox(height: 7.h,),
                  GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MainPage()));
                      },
                      child: Container(
                        height: 40, width: 170,
                         decoration: BoxDecoration(
                          
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text("Done", style: TextStyle(color: Colors.white,
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
          ),
        ),
      ),
    );
  }
}

class BookingStae extends StatelessWidget {
  Widget text;
  BookingStae({ 
    required this.text
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: text
    );
  }
}