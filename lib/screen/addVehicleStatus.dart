import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../constants/colors_palette.dart';
import 'MainPage.dart';

class AddVehicleStatus extends StatelessWidget {
  String text;
   AddVehicleStatus({ required this.text });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: Center(
          child: Container(
            
            child: Column(
              children: [
                SizedBox(height: 7.h,),
                Text('Success', style: TextStyle(
                  color: kPrimaryColor,
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.bold
      
                ),),
                SizedBox(height: 7.h,),
               
                SizedBox(
                  height: 40.h, width: double.infinity,
                  child: Lottie.asset('assets/ticker.json', fit: BoxFit.fill),
                ),
                SizedBox(height: 5.h,),
                Text(
                     text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 19,
                        fontFamily: "Poppins"),
                    ),
                    SizedBox(height: 12.h,),
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
                        child: Text("Go to Home", style: TextStyle(color: Colors.white,
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
    );
  }
}