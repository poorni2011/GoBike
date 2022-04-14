import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bike_service_app/DataModels/common_data_model.dart';
import 'package:bike_service_app/common/ApiList.dart';
import 'package:bike_service_app/common/utilities.dart';
import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/constants/constants.dart';
import 'package:bike_service_app/screen/addVehicleStatus.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';


import 'MainPage.dart';

class AddUserVehicle extends StatefulWidget {
  const AddUserVehicle({Key? key}) : super(key: key);

  @override
  _AddUserVehicleState createState() => _AddUserVehicleState();
}

class _AddUserVehicleState extends State<AddUserVehicle> {
  //get Image
  File? img;
  String image = '';
  bool? isLoading;
  // File? cameraImg;

  Future getImage(ImageSource source) async {
    final pickedimg = await ImagePicker().getImage(source: source);

    // final imagetem = File(pickedimg!.path);
    setState(() {
      if (pickedimg != null) {
        image = pickedimg.path;
        img = File(pickedimg.path);
        print(image);
        print('images are viewable');
      } else {
        print('no images');
      }
      // this.img = imagetem;
    });
  }

  //select year
  DateTime? _selectedYear;
  String getYear() {

    if (_selectedYear == null) {
      return 'Select Year';
    } else {
      return '${_selectedYear!.year}';
    }
  }

//radio button
  String? btnval;

  void _handleRadioButton(String? value) {
    setState(() {
      btnval = value!;

      print(btnval);
    });
   
    //  Utilities.setPreference(key, value);
  }

  //   bool? hasInternet;
  //   late StreamSubscription internetStream;

  // @override
  // void initState() {
  //   super.initState();
  //   internetStream= InternetConnectionChecker().onStatusChange.listen((status) { 
  //     final hasInternet = status == InternetConnectionStatus.connected;
  //     setState(() {
  //       this.hasInternet = hasInternet;
  //     });
  //   });
  // }
   
  //  @override
  //  void dispose() {
  //    internetStream.cancel();
  //    super.dispose();
  //  }
  

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController brandNameController = TextEditingController();
   TextEditingController plateNoController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController isSingleUser = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            'Add Vehicle',
            style:
                TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
          ),
          
        ),
        body: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    'assets/images/formPage.png',
                    fit: BoxFit.contain,
                    height: 160,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      validator: (brandname) {
                        if (brandname!.isEmpty) {
                          return 'Please Enter Brand Name!';
                        }
                        return null;
                      },
                      controller: brandNameController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          labelText: 'Vehicle Brand Name',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins')),
                    ),
                  ),
                  //  Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 30),
                  //   child: TextFormField(
                  //     controller: vehicleModelController,
                  //     cursorColor: Colors.black,
                  //     decoration: InputDecoration(
                  //         labelText: 'Vehicle Model',
                  //         labelStyle: TextStyle(fontWeight: FontWeight.w400)),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      validator: (plateNo) {
                        if (plateNo!.isEmpty) {
                          return 'Please Enter Plate No!';
                        }
                        return null;
                      },
                      controller: plateNoController,
                      // validator: MaxLengthValidator(8, errorText: ''),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          labelText: 'Plate No',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins')),
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(children: [
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                'Is Single User?',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins'),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Radio<String>(
                                value: 'Yes',
                                groupValue: btnval,
                                onChanged: _handleRadioButton,
                              ),
                              Text(
                                'Yes',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins'),
                              ),
                              Radio<String>(
                                  value: 'No',
                                  groupValue: btnval,
                                  onChanged: _handleRadioButton),
                              Text(
                                'No',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins'),
                              ),
                            ]),
                          ),

                  // validator: (btnval){
                  //   if(btnval == null){
                  //     return "ENTER";
                  //   }
                  // },

                  // MyRadioButton(),

  //                 FormBuilderRadioGroup(
  // decoration: InputDecoration(labelText: 'My best language'),
  // name: 'my_language',
  
  // options: [
  //   'Dart',
  //   'Kotlin',
  //   'Java',
  //   'Swift',
  //   'Objective-C',
  //   'Other'
  // ]
  //   .map((lang) => FormBuilderFieldOption(value: lang))
  //   .toList(growable: false),
  // ),
  // FormBuilderTextField(
  //   name: 'specify',
   
  //   decoration:
  //       InputDecoration(labelText: 'If Other, please specify'),
  //   validator: (val) {
  //     if(_formkey.currentState!.validate()){
          
  //     }
  //     // if (_formkey.currentState!.fields['my_language']?.value ==
  //     //         'Other' &&
  //     //     (val == null || val.isEmpty)) {
  //     //   return 'Kindly specify your language';
  //     // }
  //     // return null;
  //   },
  // ),

                  SizedBox(
                    height: 10,
                  ),
                  // SelectYear(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(children: [
                      Text(
                        'Year Of Purchase',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (
                                context,
                              ) {
                                return AlertDialog(
                                  title: Text(
                                    'Select Year',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins'),
                                  ),
                                  content: Container(
                                    width: 300,
                                    height: 300,
                                    child: YearPicker(
                                        firstDate: DateTime(1970),
                                        lastDate: DateTime.now(),
                                        selectedDate: DateTime.now(),
                                        onChanged: (val) {
                                          setState(() {
                                            this._selectedYear = val;

                                            print(_selectedYear?.year);
                                          });

                                          Navigator.pop(context);
                                        }),
                                  ),
                                );
                              });
                        },
                        child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                                child: Text(
                              getYear(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins'),
                            ))),
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 39, top: 20),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Vehicle Image',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins'),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Container(
                                child: img != null
                                    ? GestureDetector(
                                      onTap: (){
                                        showDialog(context: context, builder: (context){
                                          return AlertDialog(
                                            title: Image.file(img!),
                                            actions: [
                                              IconButton(onPressed: (){
                                                Navigator.pop(context);
                                              }, icon: Icon(Icons.arrow_forward))
                                            ],
                                          );
                                        });
                                      },
                                      child: Image.file(
                                          img!,
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                    )
                                    : Center(
                                        child: Image.network(
                                        "https://cdn-icons-png.flaticon.com/512/1040/1040241.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      )),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    getImage(ImageSource.gallery);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 130,
                                    child: Center(
                                      child: Text(
                                        'Image From Gallery',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white10,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                  onTap: () {
                                   
                                      getImage(ImageSource.camera);
                                  
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 130,
                                    child: Center(
                                        child: Text(
                                      'Image From Camera',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11,
                                          fontFamily: 'Poppins'),
                                    )),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white10,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // GetImage(),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                         
                           
                        if(btnval == null){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Fill the all details')));
                        }else if(_selectedYear == null){
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Fill the all details')));
                        }else if(img?.path == null){
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Fill the all details')));
                        }
                        else
                        {
                              addVehicle();
                       }
                      
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        height: 40,
                        width: 170,
                        child: Center(
                            child: isLoading == true ? SizedBox(
                                   height: 28,
                                width: 25,
                                  child: CircularProgressIndicator( strokeWidth: 3, color: Colors.black,)) 
                            : Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                             
                              fontSize: 16,
                              fontFamily: 'Poppins'),
                        )),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),

                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
                  },
                  child: Container(
                    height: 40, width: 170,
                     decoration: BoxDecoration(
                       border: Border.all(color: kPrimaryColor),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text("Skip", style: TextStyle(color: kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                  
                                  fontSize: 16,
                                  fontFamily: 'Poppins'),
                  ),
                    ),
                  ),
                ),
                SizedBox(height: 10,)
                //   ElevatedButton(
                //   style: ButtonStyle(backgroundColor:MaterialStateProperty.all(kPrimaryColor)),
                // onPressed: () {
                //   Navigator.pushReplacement(context,
                //       MaterialPageRoute(builder: (context) => MainPage()));
                // },
                // child: Text(
                //   'Skip',
                //   style: TextStyle(
                //       color: Colors.white, fontFamily: 'Poppins', fontSize: 16),
                // ))
                
                ],
              ),
            ),
          ),
        )) ;
  }

Box box = Hive.box('API_BOX');
  Future addVehicle() async {
    //  Map mappeddata = {
    //     'brand_name' : brandNameController.text,
    //     'plate_no' : plateNoController.text,
    //     'is_single_user' : btnval,
    //     'year_of_purchase' : _selectedYear,
    //     'image' : img,
    //  };

     setState(() {
            isLoading = true;
          });

    if (brandNameController.text.isNotEmpty &&
        plateNoController.text.isNotEmpty
         && btnval!.isNotEmpty && _selectedYear.toString().isNotEmpty && img!.path.isNotEmpty) {
           String token = await box.get(Constants.USER_TOKEN);
      
      final headers = {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token'
      };
      var request =
          await http.MultipartRequest('POST', Uri.parse(API.addUserVehicleUrl));
      request.fields['brand_name'] = brandNameController.text;
      request.fields['plate_no'] = plateNoController.text;

      request.fields['is_single_owner'] = btnval!;
      request.fields['year_of_purchase'] = _selectedYear!.year.toString();
      request.files.add(await http.MultipartFile.fromPath('image', img!.path));
      request.headers.addAll(headers);
      print(request.files);

      request.send().then((response) async {
        if (response.statusCode == 200) {

          box.put(Constants.BRAND_NAME, brandNameController.text);
          box.put(Constants.PLATE_NO, plateNoController.text);
          box.put( Constants.YEAR_OF_PURCHASE, _selectedYear?.year.toString());
          box.put(Constants.ADDED_VEHICLE_INFO, Constants.INFO_ADDED);
          box.put(Constants.VEHICLE_IMAGE, image);


          // Utilities.setPreference(
          //     Constants.BRAND_NAME, brandNameController.text);
          // Utilities.setPreference(Constants.PLATE_NO, plateNoController.text);
          // Utilities.setPreference(
          //     Constants.YEAR_OF_PURCHASE, _selectedYear?.year.toString());
          //   print('11111');
           
          // Utilities.setPreference(Constants.ADDED_VEHICLE_INFO, Constants.INFO_ADDED);
          // Utilities.setPreference(Constants.VEHICLE_IMAGE, image);
        
               print('2222');
          // print(data);
          final res = await http.Response.fromStream(response);
          print(res.body);
          CommonDataModel data = CommonDataModel.fromJson(jsonDecode(res.body));

         setState(() {
           isLoading = false;
         });

            //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AddVehicleStatus(text: data.message.toString(),)), (route) => false);
            //  AddVehicleStatus(text: data.message.toString(),);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                   shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Lottie.asset('assets/tick.json', 
                    repeat: false,
                    height: 30.h,
                    width: 30.w,),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      data.message.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    ),
                  ),
                  actions: [
                    Center(
                  child: ElevatedButton(
                    style: 
                    ButtonStyle(
                       backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    ))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Done',
                        style: TextStyle(fontFamily: 'Poppins'),
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
                 SizedBox(height: 2.h,)
                    // TextButton(
                    //   child: Text('Ok', style: TextStyle(fontFamily: "Poppins"),),
                    //   onPressed: () {
                        
                    //     Navigator.pushAndRemoveUntil(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => MainPage()),
                    //         (route) => false);
                    //   },
                    // ),
                  ],
                );
              });
        } else {
          print('failed');
        }
      });
    }
  }
}
