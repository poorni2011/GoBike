import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/utilities.dart';
import '../constants/constants.dart';

class Getcall extends StatefulWidget {
  const Getcall({ Key? key }) : super(key: key);

  @override
  _GetcallState createState() => _GetcallState();
}

class _GetcallState extends State<Getcall> {

  String? serviceNum;
  Box box = Hive.box('API_BOX');
  getInfo() async {

    serviceNum = await box.get(Constants.SERVICE_NUMBER);


    setState(() {
      serviceNum =serviceNum;


    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('24X7', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, color: Colors.black),),
      ),
      body: Center(
        child: GestureDetector(
          onTap: ()async{
             await launch("tel:$serviceNum");
          },
          child: Container(
            height: 100, width: 100,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(50)
            ),
            child: Center(child: Text('Call Now ',style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: Colors.black), )),
          ),
        ),
      ),
    );
  }
}