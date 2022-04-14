
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/screen/Homepage.dart';
import 'package:bike_service_app/screen/NoInternet.dart';
import 'package:bike_service_app/screen/Rewardspage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../DataModels/GetAboutDataModel.dart';
import '../common/ApiList.dart';
import '../common/utilities.dart';
import '../constants/constants.dart';
import 'Bookingpage.dart';
import 'ComingSoonPage.dart';
import 'Getcall.dart';
import 'Profilepage.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({ Key? key }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  
 
  int _currentindex =0;
   final tabs = [
     HomePage(),
     Bookingpage(),
     Getcall(),
     ComingSoon(),
     Profilepage()
   ];
   
    Box box = Hive.box('API_BOX');
     
    
    
   @override
   void initState() {
     super.initState();

  //    Future.delayed(Duration.zero, () {
  //     this. showMsg();
  //  });
    
   
      // getInfo();

    Future.delayed(Duration.zero, () {
       this.showMsg();
   });
    
      getAbout();
      
   }

   
    showMsg(){
       String isFirstRun =  box.get(Constants.IS_FIRST_TIME_RUN).toString();
    print(isFirstRun);
    print('kjksj');
    if(isFirstRun == 'null'){
      print('is First Run true');
       this.welcomeMsg();
      box.put(Constants.IS_FIRST_TIME_RUN, 'true');
     
    }
   }

   welcomeMsg(){
   
     return  showDialog(
       barrierDismissible: false,
        context: context,
        builder: (context){
         
          return Container(
           
           
            height: 10,width: 120,
            child: AlertDialog(
              
                      shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              backgroundColor: kPrimaryColor,
             title: Column(
                children: [
                  Container(
                child: Center(
                  child: Image.asset('assets/images/logoo.png',
                                fit: BoxFit.cover,
                                height: 20.h,  width: 25.w,),
                ),
                
              ),
              SizedBox(height: 1.h,),
                  Text('Welcome To' ,style: TextStyle(
                    fontFamily: 'Poppins',
                     color: Colors.white
                  ),),
              Row(
                children: [
                  Text('GoBike Home Family', style: TextStyle(
                        fontFamily: 'Poppins',
                         color: Colors.white
                      ),),
                      Expanded(
                        child: SizedBox(
                          height: 30, width: 30,
                          child: Image.asset('assets/icons/emoji.png')),
                      ),
                ],
              ),
              SizedBox(height: 2.h,),
               Center(
                  child: ElevatedButton(
                    style: 
                    ButtonStyle(
                       backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    ))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Go To Home',
                        style: TextStyle(fontFamily: 'Poppins',
                        color: kPrimaryColor),
                      ),
                    ),
                    onPressed: () {
                      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainPage()));
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                          (route) => false);
                    },
                  ),
                ),
                  // Text("Welcome to GoBike Home Family",
                  // style: TextStyle(
                  //   fontFamily: 'Poppins',
                  //   fontSize: 18,
                  // ),)
                ],
              ),
            ),
          );
        });
   
  }
   

  

  //   welcomeMsg(){
   
  //    return  showDialog(
  //       context: context,
  //       builder: (context){
         
  //         return Container(
           
           
  //           height: 10,width: 120,
  //           child: AlertDialog(
  //                     shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //             backgroundColor: kPrimaryColor,
  //            title: Column(
  //               children: [
  //                 Container(
  //               child: Center(
  //                 child: Image.asset('assets/images/logoo.png',
  //                               fit: BoxFit.cover,
  //                               height: 20.h,  width: 25.w,),
  //               ),
                
  //             ),
  //             SizedBox(height: 1.h,),
  //                 Text('Welcome To' ,style: TextStyle(
  //                   fontFamily: 'Poppins',
  //                    color: Colors.white
  //                 ),),
  //             Row(
  //               children: [
  //                 Text('GoBike Home Family', style: TextStyle(
  //                       fontFamily: 'Poppins',
  //                        color: Colors.white
  //                     ),),
  //                     Expanded(
  //                       child: SizedBox(
  //                         height: 30, width: 30,
  //                         child: Image.asset('assets/icons/emoji.png')),
  //                     ),
  //               ],
  //             ),
  //             SizedBox(height: 2.h,),
  //              Center(
  //                 child: ElevatedButton(
  //                   style: 
  //                   ButtonStyle(
  //                      backgroundColor: MaterialStateProperty.all(Colors.white),
  //                       shape:
  //                           MaterialStateProperty.all<RoundedRectangleBorder>(
  //                               RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(20.0),
  //                                   ))),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(10.0),
  //                     child: Text(
  //                       'Go To Home',
  //                       style: TextStyle(fontFamily: 'Poppins',
  //                       color: kPrimaryColor),
  //                     ),
  //                   ),
  //                   onPressed: () {
  //                     //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainPage()));
  //                     Navigator.pushAndRemoveUntil(
  //                         context,
  //                         MaterialPageRoute(builder: (context) => MainPage()),
  //                         (route) => false);
  //                   },
  //                 ),
  //               ),
  //                 // Text("Welcome to GoBike Home Family",
  //                 // style: TextStyle(
  //                 //   fontFamily: 'Poppins',
  //                 //   fontSize: 18,
  //                 // ),)
  //               ],
  //             ),
  //           ),
  //         );
  //       });
   
  // }

   GetAboutDataModel _getAboutInfo = GetAboutDataModel();
  getAbout() async {
    var response = await http.get(
      Uri.parse(API.getAbout),
    );
    print("about : ${jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      setState(() {
        _getAboutInfo = GetAboutDataModel.fromJson(jsonDecode(response.body));
       
      });
    } else {
      print(response.body);
    }
  }

  // String? serviceNum;
  // getInfo() async {
  //   serviceNum = await box.get(Constants.SERVICE_NUMBER);


  //   setState(() {
  //     serviceNum =serviceNum;


  //   });
  // }
  
  void navigationTapped(int page) {
  if (page == 2) {
    return;
  } else {
    setState(() {
      _currentindex = page;
    });
  }
}
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentindex,
      onTap: navigationTapped,
      type: BottomNavigationBarType.fixed,
         selectedItemColor: Colors.black,
      items: [
         BottomNavigationBarItem(
          icon: Icon(Icons.home, ), 
        label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, ),
         label: "Bookings"),
        BottomNavigationBarItem(
          icon: Icon(Icons.people, ),
        label : "Assistance",),
        BottomNavigationBarItem(
          icon: Icon(Icons.people, ), 
        label : "Rewards"),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, ), 
         label: "Settings"),
      ],
    
    ),
       floatingActionButton: FloatingActionButton(
       child: Text('24X7'),
       backgroundColor: kPrimaryColor,
       onPressed: ()async{
        await launch("tel:${_getAboutInfo.serviceNumber.toString()}");
       
       },
     ),
     floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    ) ;
   
  }
}