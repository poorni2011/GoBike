import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Design extends StatefulWidget {
  const Design({ Key? key }) : super(key: key);

  @override
  _DesignState createState() => _DesignState();
}

class _DesignState extends State<Design> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                     Color(0x55E89216),
                      Color(0x88E89216),
                      Color(0xccE89216),
                      Color(0xFFE89216),
                    ]
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                           Container(
                             height: 160, width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: kPrimaryColor,
                                    border: Border.all(color: Colors.black, width: 3)
                                  ),
                            child: Center(
                              child: Image.asset(
                                      "assets/images/logo.png",
                                      width: 110,
                                      height: 110,
                                    ),
                            ),
                          ),
                               SizedBox(height: 25,),
                               
                               Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              "Enter Your Mobile Number to Create account",
                              style: TextStyle(fontFamily: "Poppins",
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                               fontSize: 19,
                              ),
                            ),
                          ),
                      SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: IntlPhoneField(
                            // validator: (mobile) {
                            //   String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                            //   RegExp regExp = new RegExp(pattern);
                            //   if (mobile!.isEmpty)
                            //     return 'Enter Your Mobile Number!';
                            //   else if (mobile.length >= 11)
                            //     return 'Enter 10 digit Number only';
                            //   else if (!regExp.hasMatch(mobile))
                            //     return 'Please Enter Valid Mobile Number';
                            //   return null;
                            // },
                            showDropdownIcon: false,
                            initialCountryCode: "IN",
                            decoration: InputDecoration(
                                    hintText: "Mobile Number",
                                    hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                    )),
                            onChanged: (phoneNumber) {
                              setState(() {
                                    // this.phoneNo = phoneNumber.completeNumber;
                              });
                            },
                          ),
                                  ),
                                ),
                            SizedBox(
                            height: 28,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white)
                            ),
                              onPressed: () async {
                                // if (_formKey.currentState!.validate()) {
                                  
                                //     verifyPhone();
                                // }
                              },
                              // child: isLoading == true ?
                              // SizedBox(
                              //            height: 19,
                              //         width: 20,
                              //           child: CircularProgressIndicator( strokeWidth: 3, color: Colors.black,)) :
                              child: Text(
                                'Send OTP',
                                style: TextStyle(fontFamily: 'Poppins', color: kPrimaryColor),
                              )),

                  ]
                ),
              )
            ],
          ),
        ),),
    );
  }
}





//  Padding(
//                          padding: const EdgeInsets.symmetric(horizontal: 20, ),
//                          child: Container(
//                            padding: EdgeInsets.symmetric(vertical: 40),
//                            width: double.infinity,
//                            decoration: BoxDecoration(
//                              color: Colors.white
//                            ),
//                            child: Column(
//                              children : [
                              
//                                  Container(
//                              height: 160, width: 160,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(100),
//                                     color: kPrimaryColor,
//                                     border: Border.all(color: Colors.black, width: 3)
//                                   ),
//                             child: Center(
//                               child: Image.asset(
//                                       "assets/images/DesExpertService.png",
//                                       width: 110,
//                                       height: 110,
//                                     ),
//                             ),
//                           ),
//                                SizedBox(height: 25,),
                               
//                                Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 30),
//                             child: Text(
//                               "Enter Your Mobile Number to Create account",
//                               style: TextStyle(fontFamily: "Poppins", fontSize: 16),
//                             ),
//                           ),
//                                SizedBox(height: 10,),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                                   child: IntlPhoneField(
//                             // validator: (mobile) {
//                             //   String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
//                             //   RegExp regExp = new RegExp(pattern);
//                             //   if (mobile!.isEmpty)
//                             //     return 'Enter Your Mobile Number!';
//                             //   else if (mobile.length >= 11)
//                             //     return 'Enter 10 digit Number only';
//                             //   else if (!regExp.hasMatch(mobile))
//                             //     return 'Please Enter Valid Mobile Number';
//                             //   return null;
//                             // },
//                             showDropdownIcon: false,
//                             initialCountryCode: "IN",
//                             decoration: InputDecoration(
//                                   hintText: "Mobile Number",
//                                   hintStyle: TextStyle(
//                                     fontFamily: 'Poppins',
//                                   )),
//                             onChanged: (phoneNumber) {
//                               setState(() {
//                                   // this.phoneNo = phoneNumber.completeNumber;
//                               });
//                             },
//                           ),
//                                 ),
//                             SizedBox(
//                             height: 40,
//                           ),
//                           ElevatedButton(
//                             style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all(kPrimaryColor)
//                             ),
//                               onPressed: () async {
//                                 // if (_formKey.currentState!.validate()) {
                                  
//                                 //     verifyPhone();
//                                 // }
//                               },
//                               // child: isLoading == true ?
//                               // SizedBox(
//                               //            height: 19,
//                               //         width: 20,
//                               //           child: CircularProgressIndicator( strokeWidth: 3, color: Colors.black,)) :
//                               child: Text(
//                                 'Send OTP',
//                                 style: TextStyle(fontFamily: 'Poppins'),
//                               )),
                              
//                              ]
//                            ),
//                          ),
//                        )
                    