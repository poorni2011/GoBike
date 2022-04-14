
import 'dart:convert';

import 'package:bike_service_app/DataModels/BookingSuccessDataModel.dart';
import 'package:bike_service_app/common/ApiList.dart';
import 'package:bike_service_app/common/utilities.dart';
import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/constants/constants.dart';
import 'package:bike_service_app/screen/MainPage.dart';
import 'package:bike_service_app/screen/addVehicleStatus.dart';
import 'package:bike_service_app/screen/bookingStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../DataModels/GetAboutDataModel.dart';
import '../DataModels/get_cities_data_model.dart';

class Booking extends StatefulWidget {
  String serviceId = "";
  
  Booking({required this.serviceId, });

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String? name;
  String? email;
  String? phone;
  String? plateNo;
  String? vehicleName;
  String? city;
  String? isFristMsg;
  String? defaultCity;
   

  Box box = Hive.box("API_BOX");

  GetAboutDataModel _getAboutInfo = GetAboutDataModel();
  getAbout()async{
    var response = await http.get(Uri.parse(API.getAbout),);
    print("about : ${jsonDecode(response.body)}");
    if(response.statusCode == 200){
      setState(() {
         
        _getAboutInfo =  GetAboutDataModel.fromJson(jsonDecode(response.body));
       
      });
    }
    else{
      print(response.body);
    }
  }

   List<GetCitiesDataModel> _getCities = <GetCitiesDataModel>[];
      getCities() async {
    var url = Uri.parse(API.getCities);

    var response = await http.get(url);

    var cities = jsonDecode(response.body);

    print(cities);
    print(cities);
    print("cities");

    print(cities);
    print("cities");

    if (response.statusCode == 200) {
      print("dfhjksfhd");
      setState(() {
        print("dfhjksfhdaaa");
        _getCities = jsonDecode(response.body)
            .map<GetCitiesDataModel>(
                (_item) => GetCitiesDataModel.fromJson(_item))
            .toList();
        print("dfhjksfhd" + _getCities.length.toString());
        box.put(Constants.DEFAULT_CITY, _getCities.first.name.toString());
      });
    
    } else {
      Utilities.showToast(context, response.body);
    }
  }
  getInfo() async {

   name = await box.get(Constants.USER_NAME) ?? "";
    email = await box.get(Constants.USER_EMAIL) ?? "";
    phone = await box.get(Constants.PHONE_NO) ?? "";
    plateNo = await box.get(Constants.PLATE_NO) ?? "";
    vehicleName = await box.get(Constants.BRAND_NAME) ?? "";
    city = await box.get(Constants.CITY_NAME) ?? "";
    isFristMsg = await box.get(Constants.IS_FIRST_MSG) ?? "";
    defaultCity = await box.get(Constants.DEFAULT_CITY) ?? '';
    print('default Boo $defaultCity');

    // name = await Utilities.getPreference(Constants.USER_NAME) ?? "";
    // email = await Utilities.getPreference(Constants.USER_EMAIL) ?? "";
    // phone = await Utilities.getPreference(Constants.PHONE_NO) ?? "";
    // plateNo = await Utilities.getPreference(Constants.PLATE_NO) ?? "";
    // vehicleName = await Utilities.getPreference(Constants.BRAND_NAME) ?? "";
    // city = await Utilities.getPreference(Constants.CITY_NAME) ?? "";
    // isFristMsg = await Utilities.getPreference(Constants.IS_FIRST_MSG) ?? "";
    setState(() {
      name =name;
      defaultCity = defaultCity;
    });
  }

  
  

// address
 
  
  @override
  void initState() {
    // TODO: implement initState
   
    super.initState();
     getInfo();
     getCities();
  
      getAbout();
    _getPosition();
    position();

   
  }


  String? address;
  String? pincode;
  Future<Position> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> position() async {
    Position position = await _getPosition();

    GetAddress(position);
  }

  Future<void> GetAddress(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    print(placemarks);

    Placemark place = placemarks[0];

    address = '${place.street}, ${place.subLocality}';
    pincode = "${place.postalCode}";

    print("ADDRESS : ${address}");
    print("Pincode :${pincode}");

    await box.put(Constants.ADDRESS, address);
    await box.put(Constants.PINCODE, pincode);
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _vehicleNameController = TextEditingController();
  TextEditingController _vehicleNoController = TextEditingController();
  TextEditingController _vehicleModelController = TextEditingController();
  TextEditingController _complaintController = TextEditingController();

  static final List<String> items = <String>[
    'plan 1',
    'plan 2',
    'plan 3',
    'plan 4',
  ];
  String value = items.first;

//datepicker
  DateTime? date;
  DateTime initialDate = DateTime.now();

  final firstDate = DateTime.now();
  final lastDate = DateTime(2100);

  String getdateText() {
    if (date == null) {
      return 'Select Date';
    } else {
      return '${date!.day}/${date!.month}/${date!.year}';
    }
  }

  Future _pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate);

    if (newDate != null) {
      setState(() {
        date = newDate;
      });
    }
  }

//time picker
  TimeOfDay? time;
  final initialTime = TimeOfDay(hour: 7, minute: 40);

  String getTimeText() {
    if (time == null) {
      return 'Select Time';
    } else {
      final hours = time!.hour.toString().padLeft(2, '0');
      final minutes = time!.minute.toString().padLeft(2, '0');

      return '${hours}:${minutes}';
    }
  }

  Future _pickTime(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );

    if (newTime != null) {
      setState(() {
        time = newTime;
      });
    }
  }

  int _value = 1;

// getimages
  PickedFile? imageFile;
//  String? image='';
  PickedFile? pickedimg;

  Future getImage(ImageSource source) async {
    pickedimg = await ImagePicker().getImage(source: source);

    if (pickedimg != null) {
      setState(() {
        imageFile = pickedimg;
      });

      // image = pickedimg.path;
      // img = File(pickedimg.path);
      // print(image);

      print('images are viewable');
    } else {
      print('no images');
    }
  }

  

  bool isLoading = false;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        title: Text("Booking", style: TextStyle(fontFamily: 'Poppins'),),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formkey,
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
                SizedBox(height: 14,),
                //personal
                 Card(
                   borderOnForeground: true,
                  elevation: 2,
                   shadowColor: Colors.black,
                     margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            kPrimaryColor.withOpacity(0.7),
                             kPrimaryColor.withOpacity(0.5),
                            kPrimaryColor.withOpacity(0.3),
                          ]),
                          ),
                          child: Text(" Personal Info ", 
                          style: TextStyle(fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700, fontSize: 15),),
                        ),
                          Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                      validator: (name) {
                        if (name!.isEmpty) {
                          return 'Please Enter Your Name';
                        } else
                          return null;
                      },
                      controller: _nameController..text = "$name",
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.black,
                      style: TextStyle(fontFamily: "Poppins"),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: kTextColor,
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                      validator: (email) {
                        if (email!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(email)) {
                          return 'Enter a valid email!';
                        }
                        return null;
                      },
                      controller: _emailController..text = '$email',
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.black,
                      style: TextStyle(fontFamily: "Poppins"),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          color: kTextColor,
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    enabled: false,
                      // validator: (mobile) {
                      //   if (mobile!.isEmpty)
                      //     return 'Enter Your Mobile Number!';
                      //   else if (mobile.length >= 11)
                      //     return 'Enter 10 digit Number only';
                      //   return null;
                      // },
                      controller: _phoneController..text = '$phone',
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.black,
                      style: TextStyle(fontFamily: "Poppins"),
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          color: kTextColor,
                        ),
                      )),
                ),
                SizedBox(height: 25,)
                      ],
                    ),
                 ),
                   SizedBox(height: 14),
                   //address
                 Card(
                   borderOnForeground: true,
                   elevation: 2,
                    shadowColor: Colors.black,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            kPrimaryColor.withOpacity(0.7),
                             kPrimaryColor.withOpacity(0.5),
                            kPrimaryColor.withOpacity(0.3),
                          ]),
                          ),
                          child: Text(" Address Info ", style: TextStyle(fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700, fontSize: 15),),
                        ),
                        Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                      validator: (address) {
                        if (address!.isEmpty) {
                          return 'Please Enter Your Address';
                        } else
                          return null;
                      },
                      controller: _addressController,
                      maxLines: 4,
                      cursorColor: Colors.black,
                      style: TextStyle(fontFamily: "Poppins"),
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: kTextColor,
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                      validator: (pincode) {
                        if (pincode!.isEmpty) {
                          return 'Please Enter Your Pincode';
                        } else
                          return null;
                      },
                      controller: _pincodeController,
                     keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      style: TextStyle(fontFamily: "Poppins"),
                      decoration: InputDecoration(
                        labelText: 'Pincode',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: kTextColor,
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                      //  validator: (city) {
                      //     if (city!.isEmpty) {
                      //       return 'Please Enter Your City';
                      //     } else
                      //       return null;
                      //   },
                    controller: _cityController..text = "$defaultCity",
                      cursorColor: Colors.black,
                      style: TextStyle(fontFamily: "Poppins"),
                      decoration: InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: kTextColor,
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                      validator: (landmark) {
                        if (landmark!.isEmpty) {
                          return 'Please Enter Your Landmark';
                        } else
                          return null;
                      },
                      controller: _landmarkController,
                      cursorColor: Colors.black,
                      style: TextStyle(fontFamily: "Poppins"),
                      decoration: InputDecoration(
                        labelText: 'Landmark',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: kTextColor,
                        ),
                      )),
                ),
                   SizedBox(height: 25)
                      ],
                    ),
                 ),
                 SizedBox(height: 14,),
                 //vehicle
                 Card(
                   borderOnForeground: true,
                   elevation: 2,
                    shadowColor: Colors.black,
                   margin: EdgeInsets.symmetric(horizontal: 30),
                   child: Column(
                     children: [
                       SizedBox(height: 20,),
                       Container(
                         decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            kPrimaryColor.withOpacity(0.7),
                             kPrimaryColor.withOpacity(0.5),
                            kPrimaryColor.withOpacity(0.3),
                          ]),
                         ),
                         child: Text(" Vehicle Info ", style: TextStyle(fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700, fontSize: 15),),
                       ),
                       SizedBox(height: 4,),
                          Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                     validator: (vehicleName) {
                       if (vehicleName!.isEmpty) {
                         return 'Please Enter Your Vehicle Name';
                       } else
                         return null;
                     },
                     controller: _vehicleNameController..text = "$vehicleName",
                     cursorColor: Colors.black,
                     style: TextStyle(fontFamily: "Poppins"),
                     decoration: InputDecoration(
                       labelText: 'Vehicle Name',
                       labelStyle: TextStyle(
                         fontWeight: FontWeight.w700,
                         fontSize: 14.sp,
                         fontFamily: 'Poppins',
                         color: kTextColor,
                       ),
                     )),
                                 ),
                                 Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                     validator: (vehicleNo) {
                       if (vehicleNo!.isEmpty) {
                         return 'Please Enter Your Vehicle No';
                       } else
                         return null;
                     },
                     controller: _vehicleNoController..text = "$plateNo",
                     cursorColor: Colors.black,
                     style: TextStyle(fontFamily: "Poppins"),
                     decoration: InputDecoration(
                       labelText: 'Vehicle No',
                       labelStyle: TextStyle(
                         color: kTextColor,
                         fontWeight: FontWeight.w700,
                         fontSize: 14.sp,
                         fontFamily: 'Poppins',
                       ),
                     )),
                                 ),
                                 Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                     validator: (vehicleModel) {
                       if (vehicleModel!.isEmpty) {
                         return 'Please Enter Your Vehicle Model';
                       } else
                         return null;
                     },
                     controller: _vehicleModelController,
                     cursorColor: Colors.black,
                     style: TextStyle(fontFamily: "Poppins"),
                     decoration: InputDecoration(
                       labelText: 'Vehicle Model',
                       labelStyle: TextStyle(
                         color: kTextColor,
                         fontWeight: FontWeight.w700,
                         fontSize: 14.sp,
                         fontFamily: 'Poppins',
                       ),
                     )),
                                 ),
                                 Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      maxLines: 4,
                     validator: (complaint) {
                       if (complaint!.isEmpty) {
                         return 'Enter your Complaint';
                       } else
                         return null;
                     },
                     controller: _complaintController,
                     cursorColor: Colors.black,
                     style: TextStyle(fontFamily: "Poppins"),
                     decoration: InputDecoration(
                       labelText: 'Complaint Details',
                       labelStyle: TextStyle(
                         color: kTextColor,
                         fontWeight: FontWeight.w700,
                         fontSize: 14.sp,
                         fontFamily: 'Poppins',
                       ),
                     )),
                                 ),
                                 SizedBox(height: 25,)
                     ],
                   ),
                 ),

               
               
                
              
                // Row(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(left: 60),
                //       child: Column(
                //         children: [
                //           Text(
                //             'Date',
                //             style: TextStyle(
                //               color: kTextColor,
                //               fontWeight: FontWeight.w400,
                //               fontFamily: 'Poppins',
                //             ),
                //           ),
                //           RaisedButton(
                //             color: Colors.white,
                //             child: Text(
                //               getdateText(),
                //               style: TextStyle(
                //                 fontWeight: FontWeight.w400,
                //                 fontFamily: 'Poppins',
                //               ),
                //             ),
                //             onPressed: () {
                //               _pickDate(context);
                //             },
                //           ),
                //         ],
                //       ),
                //     ),
                //     SizedBox(
                //       width: 30,
                //     ),
                //     Column(
                //       children: [
                //         Text(
                //           'Time',
                //           style: TextStyle(
                //             color: kTextColor,
                //             fontWeight: FontWeight.w400,
                //             fontFamily: 'Poppins',
                //           ),
                //         ),
                //         RaisedButton(
                //           color: Colors.white,
                //           child: Text(
                //             getTimeText(),
                //             style: TextStyle(
                //               fontWeight: FontWeight.w400,
                //               fontFamily: 'Poppins',
                //             ),
                //           ),
                //           onPressed: () {
                //             _pickTime(context);
                //           },
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
               
               
               
                //         Padding(
                //   padding: const EdgeInsets.only(left: 39, top: 20),
                //   child: Container(
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             Text('Vehicle Image'),
                //             SizedBox(
                //               width: 50,
                //             ),
                //             Container(

                //               child: imageFile != null
                //                   ? Image.file(File(imageFile!.path), height: 80, width: 80, fit: BoxFit.cover,)

                //                   : Center(child: Image.asset('assets/images/no_image.jpg', height: 40, width: 40, fit: BoxFit.cover,)),
                //               decoration: BoxDecoration(
                //                 border: Border.all(
                //                   color: Colors.black
                //                 )
                //               ),
                //             ),
                //             SizedBox(
                //               height: 20,
                //             )
                //           ],
                //         ),
                //         SizedBox(
                //           height: 20,
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.only(left: 60),
                //           child: Row(
                //             children: [
                //               GestureDetector(
                //                 onTap: () {
                //                   getImage(ImageSource.gallery);
                //                 },
                //                 child: Container(
                //                   height: 30,
                //                   width: 120,
                //                   child: Center(
                //                     child: Text(
                //                       'Image From Gallery',
                //                       style: TextStyle(fontSize: 12),
                //                     ),
                //                   ),
                //                   decoration: BoxDecoration(
                //                     border: Border.all(color: Colors.black),
                //                     borderRadius: BorderRadius.circular(20),
                //                     color: Colors.white10,
                //                   ),
                //                 ),
                //               ),
                //               SizedBox(
                //                 width: 10,
                //               ),
                //               GestureDetector(
                //                 onTap: () {
                //                   getImage(ImageSource.camera);
                //                 },
                //                 child: Container(
                //                   height: 30,
                //                   width: 120,
                //                   child: Center(
                //                       child: Text(
                //                     'Image From Camera',
                //                     style: TextStyle(
                //                         fontSize: 12, fontWeight: FontWeight.w400),
                //                   )),
                //                   decoration: BoxDecoration(
                //                     border: Border.all(color: Colors.black),
                //                     borderRadius: BorderRadius.circular(20),
                //                     color: Colors.white10,
                //                   ),
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // DropDown(),
                SizedBox(
                  height: 20,
                ),
                // SubmitButton(),
                GestureDetector(
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      addBooking();

                      print('successful');
                      // print(image);
                      // print(date);
                      // print(time);
                    } else {
                      print('unsuccess');
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 170,
                    child: Center(
                        child:  isLoading == true 
                                ? SizedBox(
                                   height: 28,
                                width: 25,
                                  child: CircularProgressIndicator( strokeWidth: 3, color: Colors.black,)) 
                       : Text('Submit',
                           style: TextStyle(
                             color: Colors.white,
                             fontFamily : 'Poppins',
                             fontWeight: FontWeight.w600,
                             fontSize: 16
                           ),
                            )),
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            )),
      ),
    );
  }

  

  Future addBooking() async {
    setState(() {
      isLoading = true;
    });
    String token = await box.get(Constants.USER_TOKEN);
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $token'
    };
    if (_nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _pincodeController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _landmarkController.text.isNotEmpty &&
        _vehicleNameController.text.isNotEmpty &&
        _vehicleNoController.text.isNotEmpty &&
        _vehicleModelController.text.isNotEmpty &&
        _complaintController.text.isNotEmpty) {
         String _userId = await box.get(Constants.USER_ID);
      
      // String _booking_address_id = await Utilities.getPreference(Constants.BOOKING_SERVICE_ID);
      // print("booking service id: $_booking_address_id");
      //  String _userId = "1";

      //  print(_userId);
      
      //  var response = await http.post(Uri.parse(API.addBooking), headers: headers);
      var request =
          await http.MultipartRequest('POST', Uri.parse(API.addBooking));
      request.fields['user_id'] = _userId;
      request.fields['service_id'] = widget.serviceId;
      request.fields['booking_address_id'] = '1';
      request.fields['customer_name'] = _nameController.text;
      request.fields['phone'] = _phoneController.text;
      request.fields['email'] = _emailController.text;
      request.fields['address'] = _addressController.text;
      request.fields['pincode'] = _pincodeController.text;

      request.fields['city'] = _cityController.text;
      request.fields['landmark'] = _landmarkController.text;
      request.fields['vehicle_name'] = _vehicleNameController.text;
      request.fields['vehicle_no'] = _vehicleNoController.text;
      request.fields['vehicle_model'] = _vehicleModelController.text;
      request.fields['complaint_details'] = _complaintController.text;
      // request.files.add(await http.MultipartFile.fromPath('image', imageFile!.path,));
      request.headers.addAll(headers);

      print(request.fields);
      // print(request.files);

      request.send().then((response) async {
        final res = await http.Response.fromStream(response);





        // var response = res;
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(res.body),
        // ));
        // showDialog(
        //      barrierDismissible: false,
        //     context: context,
        //   builder: (context){
        //     return AlertDialog(

        //         content: Text(res.body, style: TextStyle(fontWeight: FontWeight.w500), ),

        //     );
        //   });

        if (response.statusCode == 200) {
          BookingSucessDataModel dataModel = BookingSucessDataModel.fromJson(jsonDecode(res.body.toString())) ;

         
          print(dataModel.isFirst);

          print(dataModel.message);
          print("dghdhghhffhgghfhhghg");
          print(res.body);
           setState(() {
             isLoading = false;
           });
           if(dataModel.status == Constants.RESPONSE_SUCCESS){

            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>  Bookingstatus(
            //     text: Column(
            //       children: [
            //          dataModel.isFirst == "true"?
            //            Padding(
            //              padding: const EdgeInsets.symmetric(horizontal: 25),
            //              child: Text(
            //          _getAboutInfo.isFirstMsg.toString(),
            //             style: TextStyle(
            //         fontSize: 14.sp,
            //         fontWeight: FontWeight.w800,color: Colors.red, fontFamily: 'Poppins'),
            //              ),
            //            ): Container(),
            //              SizedBox(height: 4.h),
            //              Text(
            //                dataModel.message.toString(),
            //                style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins', fontSize: 16.sp)
            //              ),
            //       ],
            //     ))), (route) => false);
            
            showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Lottie.asset(
                  'assets/tick.json',
                  repeat: false,
                  height: 30.h,
                  width: 30.w,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [     
                    // dataModel.isFirst == "true"?        
                    Text(
                      _getAboutInfo.isFirstMsg.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 14.sp,
                          fontFamily: 'Chakra Petch',
                          ),
                          ) ,
                          // : Container(),
                  
                    SizedBox(
                      height: 20,
                    ),
                    Text( dataModel.message.toString(),
                    textAlign: TextAlign.center,
                        style: TextStyle(
                           fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Chakra Petch',
                        )),
                  ],
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
              ],
            );
          });
           
           }else{
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
               content: Text(dataModel.message.toString()),

             ));
           }

            
         
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(res.body),
               
          ));
        }
      });
      // var info = jsonDecode(response.body);
      // print(info);

    } else {
      print('122222222');
    }
  }
  
}
