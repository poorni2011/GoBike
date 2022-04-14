import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bike_service_app/DataModels/register_data_model.dart';
import 'package:bike_service_app/common/ApiList.dart';
import 'package:bike_service_app/common/utilities.dart';
import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/constants/constants.dart';
import 'package:bike_service_app/screen/AddUserVehicle.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class Registerpage extends StatefulWidget {
  String? mobile;

  Registerpage({
    this.mobile,
  });

  @override
  _RegisterpageState createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  bool isLoading = false;

  Box box = Hive.box('API_BOX');

  

  @override
  void setState(VoidCallback fn) {
    isLoading = false;

    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Container(
            
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(20)
               ),
            
            margin: EdgeInsets.only(left: 7.w, right: 7.w, top: 14.h, ),
            child: Container(

              decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        // offset: Offset(, 1),
                        blurStyle: BlurStyle.outer,
                        blurRadius: 4.0,
                        spreadRadius: 0.3)
                  ]),
              padding: EdgeInsets.symmetric(horizontal: 30),
              height: 80.h,
              width: double.infinity,
              child: Column(
                children: [
                 SizedBox(height: 3.h),
                   Container(
                    child: Stack(
                      children: [
                         Container(
                         height: 140, width: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: kPrimaryColor,
                        ),
                      child: Center(
                              child: Image.asset('assets/images/logoo.png',
                              fit: BoxFit.cover,
                              height: 20.h,  width: 26.w,),
                            ),
                      ),
                             
                      ],
                    ),
                  ),
                   SizedBox(height: 5.h,), 
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            kPrimaryColor.withOpacity(0.3),
                            kPrimaryColor.withOpacity(0.1),
                          ]),
                          border: Border(
                              left:
                                  BorderSide(color: kPrimaryColor, width: 5))),
                      child: Text(
                        ' Register ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h,),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal:5.w),
                    child: TextFormField(
                      controller: _nameController,
                      validator: (name) {
                        if (name!.isEmpty) {
                          return 'Please Enter Your Name';
                        } else
                          return null;
                      },
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                 SizedBox(height: 1.h,),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 5.w),
                    child: TextFormField(
                      controller: _emailController,
                      //  autovalidate: true,
                      autofillHints: [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      validator: (email) {
                        if (email!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(email)) {
                          return 'Enter a valid email!';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 1.h,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: TextFormField(
                     
                       controller: _numberController..text = widget.mobile!,
                      //  autovalidate: true,

                     enabled: false,
                      cursorColor: Colors.black,
                      //  validator: (mobile){
                      //    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                      //    RegExp regExp = new RegExp(pattern);
                      //     if(mobile!.isEmpty)
                      //       return 'Enter Your Mobile Number!';
                      //     else if(mobile.length>= 11)
                      //       return 'Enter 10 digit Number only';
                      //     else if(!regExp.hasMatch(mobile))
                      //         return 'Please Enter Valid Mobile Number';
                      //     return null;
                      //  },
                      decoration: InputDecoration(
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: 'Mobile Number',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                 SizedBox(height: 5.h,),
                  Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = false;
                          });
                          
                         
                          register();
                         
                          // print('Successful');
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
                        } else {
                          print('Unsuccess');
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 160,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: isLoading == true
                                ? SizedBox(
                                    height: 28,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.black,
                                    ))
                                : Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                      ),
                    ),
                  ),

                 
                ],
              ),
            ),
          ),
        )));
  }

  Future register() async {
    Map mappeddata = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _numberController.text,
    };
    print('Json Data: $mappeddata');

   
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _numberController.text.isNotEmpty) {
      var response = await http.post(Uri.parse(API.registerUrl), body: mappeddata);

      setState(() {
        isLoading = true;
      });
      var info = jsonDecode(response.body);
      print('data ${info}');

      RegisterDataModel val = RegisterDataModel.fromJson(info);

      if (val.status == Constants.RESPONSE_SUCCESS) {
        box.put(Constants.USER_ID, val.data!.id.toString());
         box.put(Constants.USER_NAME, val.data!.name.toString());
           box.put(Constants.USER_EMAIL, val.data!.email.toString());
           box.put(Constants.USER_TOKEN, val.accessToken.toString());
           box.put(Constants.USER_TOKEN_TYPE, val.tokenType.toString());
           box.put(Constants.USER_LOGIN_STATUS, Constants.LOGGED_IN);
          //  box.put(Constants.USER_LOGIN_STATUS, Constants.USER_REFERAL_CODE);

           final status = box.get(Constants.USER_LOGIN_STATUS);
           print('Status : $status');

        // Utilities.setPreference(Constants.USER_ID, val.data!.id.toString());
        // Utilities.setPreference(Constants.USER_NAME, val.data!.name.toString());
        // Utilities.setPreference(
        //     Constants.USER_EMAIL, val.data!.email.toString());
        // Utilities.setPreference(
        //     Constants.USER_TOKEN, val.accessToken.toString());
        // Utilities.setPreference(
        //     Constants.USER_TOKEN_TYPE, val.tokenType.toString());
        // Utilities.setPreference(
        //     Constants.USER_LOGIN_STATUS, Constants.LOGGED_IN);
        // Utilities.setPreference(
        //     Constants.USER_LOGIN_STATUS, Constants.USER_REFERAL_CODE);
       
       
        //     Utilities.setPreference(Constants.USER_ID, val.data!.id.toString());
        // Utilities.setPreference(Constants.PHONE_NO, _numberController.text);
        //    Utilities.setPreference(Constants.USER_NAME, val.data!.name);
        //    Utilities.setPreference(Constants.USER_EMAIL, val.data!.email);
        //   Utilities.setPreference(Constants.USER_TOKEN, val.accessToken);
        //   Utilities.setPreference(Constants.USER_TOKEN_TYPE, val.tokenType);
        //   Utilities.setPreference(Constants.USER_LOGIN_STATUS, Constants.LOGGED_IN);

        setState(() {
          isLoading = true;
        });

        print(val.data!.name);
        print(val.accessToken);
        print(val.data!.id);
        print(val.message);

        String? registerSuccess = val.message;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.white,
            duration: Duration(seconds: 2),
            content: Text(
              registerSuccess!,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )));

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddUserVehicle()));
        });

        //     Future.delayed(Duration(seconds: 3), () {
        //
        // });

      } else if (val.status == 0) {
        String? regisFail = val.message;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            duration: Duration(seconds: 3),
            content: Text(
              regisFail!,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid credentials'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Enter your credentials'),
      ));
    }
  }
}

//old page
//  return Scaffold(

//     // resizeToAvoidBottomInset: false,
//     body: SingleChildScrollView(
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [

//         Stack(
//           children: [
//             Image.asset('assets/images/loginPage.jpeg',
//                fit: BoxFit.cover,

//             ),

//             Padding(
//               padding: const EdgeInsets.only(top: 205),
//               child: SingleChildScrollView(
//                 child: Container(
//                 height: _height,
//                 width: _width,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40)
//                   )
//                 ),
//                 child: Column(
//                   children: [

//                     SizedBox(height: 20),

//                     SizedBox(height: 10),

//                    SizedBox(height: 10),

//                    SizedBox(height: 40),

//                   ],
//                 ),
//                           ),
//               ),
//             ),

//           ]
//         ),
//          ],
//         ),
//       ),
//     )
//   );
