import 'dart:io';

import 'package:bike_service_app/common/utilities.dart';
import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sizer/sizer.dart';
import 'AddUserVehicle.dart';

class GetVehicle extends StatefulWidget {
  const GetVehicle({Key? key}) : super(key: key);

  @override
  _GetVehicleState createState() => _GetVehicleState();
}

class _GetVehicleState extends State<GetVehicle> {
  String? brandName;
  String? plateNo;
  String? year_of_purchase;
  String? vehicle_img;
  File? imageFile;
  final borderRadius = BorderRadius.circular(20);
  Box box = Hive.box("API_BOX");

  getVehicleInfo() async {
    brandName = await box.get(Constants.BRAND_NAME);
    plateNo = await box.get(Constants.PLATE_NO);
    year_of_purchase =
        await box.get(Constants.YEAR_OF_PURCHASE);
        print(brandName);
        print(plateNo);
        print(year_of_purchase);
    
    
    setState(() {
      brandName = brandName;
      plateNo = plateNo;
      year_of_purchase = year_of_purchase;
    
      
    });
  }

  getImage()async{
    vehicle_img = await box.get(Constants.VEHICLE_IMAGE);
       

setState(() {
    vehicle_img = vehicle_img;
 

});
  }
  
  @override
  void initState() {
    getVehicleInfo();
    getImage();
    imageFile = File(vehicle_img.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: kPrimaryColor,
          title: Text(
            'My Vehicle',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16.sp),
          ),
        ),
        body: Container(
          child: Column(children: [
            Stack(
              children: [
                Container(
                  height:35.h,
                  width: double.infinity,
                  color: kPrimaryColor,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 22.h,
                    ),
                    Center(
                      child: vehicle_img == null
                          ? SizedBox(
                              height: 180,
                              width: 180,
                              child: Image.asset(
                                'assets/icons/vehiclee.png',
                              ))
                          : GestureDetector(
                            onTap: (){
                               showDialog(context: context, builder: (context){
                                          return AlertDialog(
                                            title: Image.file(imageFile!),
                                            actions: [
                                              IconButton(onPressed: (){
                                                Navigator.pop(context);
                                              }, icon: Icon(Icons.arrow_forward))
                                            ],
                                          );
                                        });
                            },
                            child: Container(
                               height: 180, width: 180,
                                padding: EdgeInsets.all(2), // Border width
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(100)),
                                child: ClipRRect(
                                  borderRadius:BorderRadius.circular(100),
                                  child:  Image.file(
                                      imageFile!,
                                      fit: BoxFit.fill,
                                    
                                  ),
                                ),
                              ),
                          )
                      // : Container(
                      //   height: 180,
                      //   width: 180,
                      //   decoration: BoxDecoration(
                      //     color: Colors.blue,
                      //     borderRadius: BorderRadius.circular(50)
                      //   ),
                      //   child: Image.file(imageFile!, fit: BoxFit.cover,),
                      // )
                      ,
                    ),
                    SizedBox(height: 7.h),
                    brandName == null &&
                            plateNo == null &&
                            year_of_purchase == null
                        ? Column(
                            children: [
                              SizedBox(
                                height: 40,
                              ),
                              Text('No Vehicle found',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400)),
                              SizedBox(
                                height: 70,
                              ),
                              SizedBox(
                                width: 145,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kPrimaryColor)),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddUserVehicle()));
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.add),
                                        Text(
                                          'Add Vehicle',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              children: [
                                detailsRow('Brand Name', brandName!),
                                SizedBox(
                                  height: 17,
                                ),
                                detailsRow('Plate No', plateNo!),
                                SizedBox(
                                  height: 17,
                                ),
                                detailsRow(
                                    'Year Of Purchase', year_of_purchase!),
                                
                                 
                              ],
                            ),
                          ),
                  ],
                )
              ],
            )
          ]),
        ));
  }

  Row detailsRow(String field, String value) {
    return Row(
      children: [
        Container(
            child: Expanded(
                child: Text(
          field,
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 12.5.sp),
        ))),
        SizedBox(
          width: 10,
        ),
        Container(
          height: 30,
          width: 200,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Center(
            child: Text(
              value,
              style:
                  TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 12.sp),
            ),
          ),
        ),
        // IconButton(onPressed: (){}, icon: Icon(Icons.delete))
      ],
    );
  }
}
