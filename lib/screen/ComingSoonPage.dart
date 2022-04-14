import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/screen/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class ComingSoon extends StatefulWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  _ComingSoonState createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("Coming soon"),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: _height * 0.20,
              ),
              Center(
                child: SizedBox(
                    height: 170,
                    width: 170,
                    child: Image.asset("assets/icons/coming_soon.png")),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Coming soon...",
                style: TextStyle(
                    
                    fontSize: 20,
                    
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
                  },
                  child: Container(
                    height: 40, width: 170,
                     decoration: BoxDecoration(
                       border: Border.all(color: kPrimaryColor),
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text("Back to Home", style: TextStyle(color: Colors.white,
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
    );
  }
}


//  Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//            children: [
//              Center(
//                child: Container(
//                  height: _height*0.75,
//                  width: _width*0.85,
//                   color: Colors.red,
//                   child: Column(
                    
//                   ),