import 'dart:async';
import 'dart:io';
import 'package:bike_service_app/screen/NoInternet.dart';
import 'package:http/http.dart'as http;
import 'package:bike_service_app/common/utilities.dart';
import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import 'AddUserVehicle.dart';


class GetProfile extends StatefulWidget {
  const GetProfile({Key? key}) : super(key: key);

  @override
  _GetProfileState createState() => _GetProfileState();
}

class _GetProfileState extends State<GetProfile> {
  String? email;
  String? name;
  String? phoneNo;
  Box box = Hive.box("API_BOX");
  bool isLoading = true;

  getProfile() async {
    email = await box.get(Constants.USER_EMAIL);
    name = await box.get(Constants.USER_NAME);
    phoneNo = await box.get(Constants.PHONE_NO);

    setState(() {
      email = email;
      name = name;
      phoneNo = phoneNo;
      print(email);
    });
  }

  @override
  void initState() {
    getProfile();
    checkInternet();
    super.initState();
  }
  
   Future refresh() async {
    setState(() {
      isLoading = true;
    });

   
    setState(() {
      isLoading = false;
      getProfile();
    });
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
          //  refresh();
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
            ));
  }
 


  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return  isInternetAvailable == true ?
     DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            elevation: 0,
            bottom: TabBar(
              labelColor: kPrimaryColor,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
             indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.white),
             tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("My Profile",
                  style:  TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700
                  ),), 
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("My Vehicle", 
                  style:  TextStyle(
                     fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700
                  ),),
                ),
              ),
              
            ]),
          ),
          body: TabBarView(children: [
           UserInfo(),
           MyVehicle()
            
          ]),
        )
    ) :
   NoInternet();

        
        
      
    
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 0.0,
    //     backgroundColor: kPrimaryColor,
    //     title: Text(
    //       'My Profile',
    //       style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16.sp),
    //     ),
    //   ),
    //   body: Container(
    //     child: Column(
    //       children: [
    //         Stack(
    //           children: [
    //             Container(
    //               height: 35.h,
    //               width: double.infinity,
    //               color: kPrimaryColor,
    //             ),
    //             Positioned(
    //               right: 32.w,
    //               top:  24.h,
    //               child: Container(
    //                 child: SizedBox(
    //                       height: 150,
    //                       width: 130,
    //                       child: Image.asset(
    //                         'assets/icons/profileeee.png',
    //                       )),
    //               ),
    //             ),
    //             Column(
    //               children: [             
    //                 SizedBox(height: 50.h),
    //                 name == null && email == null
    //                     ? Padding(
    //                       padding: EdgeInsets.only(left: 130),
    //                       child: Text('No Profile found'))
    //                     : Column(
    //                         children: [
    //                           DetailsRow('Name', name!),
    //                           SizedBox(
    //                             height: 4.h,
    //                           ),
    //                           DetailsRow('Email', email!),
    //                           SizedBox(
    //                             height: 4.h,
    //                           ),
    //                           DetailsRow('Phone', phoneNo!)
    //                         ],
    //                       ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Row DetailsRow(String field, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          field,
          style: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Poppins', fontSize: 12.5.sp),
        ),
        SizedBox(
          width: 18,
        ),
        Container(
          height: 30,
          width: 250,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Center(
            child: Text(
              value,
              style:
                  TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Poppins', fontSize: 12.sp),
            ),
          ),
        ),
        // IconButton(onPressed: (){}, icon: Icon(Icons.delete))
      ],
    );
  }
}

class UserInfo extends StatefulWidget {
  const UserInfo({ Key? key }) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  String? email;
  String? name;
  String? phoneNo;
  Box box = Hive.box("API_BOX");
bool isLoading = true;

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();

  getProfile() async {
    email = await box.get(Constants.USER_EMAIL);
    name = await box.get(Constants.USER_NAME);
    phoneNo = await box.get(Constants.PHONE_NO);

    setState(() {
      email = email;
      name = name;
      phoneNo = phoneNo;
      isLoading = false;
      print(email);
    });
  }

    
 

  //   File? img;
  // String image = '';

  //  Future getImage(ImageSource source) async {
  //   final pickedimg = await ImagePicker().getImage(source: source);

  //   // final imagetem = File(pickedimg!.path);
  //   setState(() {
  //     if (pickedimg != null) {
  //       image = pickedimg.path;
  //       img = File(pickedimg.path);
  //       print(image);
  //       print('images are viewable');
  //     } else {
  //       print('no images');
  //     }
  //     // this.img = imagetem;
  //   });
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading == true ?
    Center(
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
            ),) :
     
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 5.h,),
          Container(
            
            height: 23.h, width: 23.h,
            child: 
            Image.asset('assets/images/profile.png')
            // : Image.file(img!, fit: BoxFit.fill,)
          ),
           SizedBox(height: 2.h,) ,
          // Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15),
          //     color: kPrimaryColor
          //   ),
            
          //   height: 5.h, width: 40.w,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //      children: [
          //        Icon(Icons.add_a_photo_outlined, ),
          //        SizedBox(width: 2.w,),
          //        Text('Add Photo', style: TextStyle(
                  
          //          fontFamily: 'Poppins',
          //          fontSize: 13.sp
          //        ),),
    
          //      ],
               
          //   ),
          // ),
          // Divider(
          //   height: 3.h,
          //   thickness: 1.0,
          //   color: Colors.black
          // ),
          SizedBox(height: 3.h,),
          Container(
            child :
           name == null && email == null
               ? Padding(
                 padding: EdgeInsets.only(left: 130),
                 child: Text('No Profile found'))
               : Column(
                   children: [
                    //  Padding(
                    //    padding: const EdgeInsets.symmetric(horizontal: 50),
                    //    child: TextField(
                    //       readOnly: true,
                    //     controller: _name..text = '$name',
                    //      decoration: InputDecoration(
                    //        label: Text('Name'),
                           
                    //      ),
                    //    ),
                    //  ),
                    //  SizedBox(height: 4,),
                    //  Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 50),
                    //    child: TextField(
                    //       readOnly: true,
                    //     controller: _name..text = '$name',
                    //      decoration: InputDecoration(
                    //        label: Text('Name'),
                           
                    //      ),
                    //    ),
                    //  ),
                    //  Padding(
                    //  padding: const EdgeInsets.symmetric(horizontal: 50),
                    //    child: TextField(
                    //      readOnly: true,
                    //     controller: _name..text = '$name',
                    //      decoration: InputDecoration(
                    //        label: Text('Name'),
                           
                    //      ),
                    //    ),
                    //  ),
                     DetailsRow('Name', name!),
                     SizedBox(
                       height: 2.h,
                     ),
                     DetailsRow('Email', email!),
                     SizedBox(
                       height: 2.h,
                     ),
                     DetailsRow('Phone', phoneNo!),
                     SizedBox(
                        height: 5.h,
                     )
                   ],
                 ),
          )
              ],
            ),
          
        ) ; 
  }
  Column DetailsRow(String field, String value) {
    return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            field,
            style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins', fontSize: 14.sp, ),
          ),
        ),
      SizedBox(height: 1.h,),
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 40),
         child: Container(
          height: 30,
         
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
               value,
               overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Poppins', fontSize: 13.sp),
              ),
            ),
          ),
      ),
       ),
        
        // Container(
        //   height: 34,
        //   width: 260,
        //   decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        //   child: Center(
        //     child: Text(
        //       value,
        //       style:
        //           TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins', fontSize: 13.sp),
        //     ),
        //   ),
        // ),
        // IconButton(onPressed: (){}, icon: Icon(Icons.delete))
      ],
    );
  }
}

class MyVehicle extends StatefulWidget {
  const MyVehicle({ Key? key }) : super(key: key);

  @override
  _MyVehicleState createState() => _MyVehicleState();
}

class _MyVehicleState extends State<MyVehicle> {

   String? brandName;
  String? plateNo;
  String? year_of_purchase;
  String? vehicle_img;
  bool isLoading = true;


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
     isLoading = false;
      
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVehicleInfo();
  }

   
  @override
  Widget build(BuildContext context) {
    return isLoading == true ?
    Center(
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
            ),) :
     
   
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 5.h,),
          Container(
            
            height: 23.h, width: 23.h,
            child: 
            Image.asset('assets/icons/vehiclee.png')
            // : Image.file(img!, fit: BoxFit.fill,)
          ),
           SizedBox(height: 2.h,) ,
          
          SizedBox(height: 3.h,),
          Container(
            child :
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
                                DetailsRow('Brand Name', brandName!),
                                SizedBox(
                                  height: 17,
                                ),
                                DetailsRow('Plate No', plateNo!),
                                SizedBox(
                                  height: 17,
                                ),
                                DetailsRow(
                                    'Year Of Purchase', year_of_purchase!),
                                
                                 
                              ],
                            ),
                          ),
          )
              ],
            ),
          
        ) ; 
  }
  Column DetailsRow(String field, String value) {
    return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            field,
            style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins', fontSize: 14.sp, ),
          ),
        ),
      SizedBox(height: 1.h,),
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20),
         child: Container(
          height: 30,
         
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
              value,
               overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Poppins', fontSize: 13.sp),
              ),
            ),
          ),
      ),
       ),
        
        
        
      ],
    );
  }
}



