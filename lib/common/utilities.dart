import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:flutter/material.dart';


import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

class Utilities {

  
  
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> openMapStr(String latLong) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latLong';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
   
  static progressIndicator(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
              elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            actions: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: kPrimaryColor,
                      )),
                     SizedBox(width: 15) ,
                    Text('Loading....',
                    
                    style: TextStyle(
                      
                               fontSize: 15,
                                color: Colors.black,
                                fontFamily:'Poppins',
                                fontWeight: FontWeight.w400,
                              ),),
                   
                   
                  ],
                ),
              ),
              
              ],
            
          );
        });
  }
  static hideToast(BuildContext context){

  }
  static showToast(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
    );

ScaffoldMessenger.of(context).showSnackBar(snackBar);
              
  }

  // static getUserPreferences() async {
  //   var user = Map();
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   user['name'] = preferences.get('user_name');
  //   user['email'] = preferences.get('user_email');
  //   return user;
  // }

  // static setPreferenceName(name, email) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setString('user_name', name);
  //   preferences.setString('user_email', email);
  // }

  // static setPreference(key, value) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setString(key, value);
  // } //used

  // static setUserToken(value) async {
  //   Utilities.setPreference('USER_TOKEN', value);
  // }

  // static getUserToken() async {
  //   return Utilities.getPreference('USER_TOKEN');
  // }

  // static setUserTempToken(value) async {
  //   Utilities.setPreference('USER_TEMP_TOKEN', value);
  // }

  // static getUserTempToken() async {
  //   return Utilities.getPreference('USER_TEMP_TOKEN');
  // }

  // static setCartCount(value) async {
  //   Utilities.setPreference('CART_COUNT', value);
  // }

  // static getCartCount() async {
  //   return Utilities.getPreference('CART_COUNT');
  // }

  // static setLoginType(value) async {
  //   Utilities.setPreference('LOGIN_TYPE', value);
  // }

  // static setAlertStatus(value) async {
  //   Utilities.setPreference('IS_ANY_ALERT', value);
  // }

  // static getAlertStatus() async {
  //   return Utilities.getPreference('IS_ANY_ALERT');
  // }

  // static getLoginType() async {
  //   return Utilities.getPreference('LOGIN_TYPE');
  // }

  // static setLoginSkipped(value) async {
  //   Utilities.setPreference('IS_SKIPPED', value);
  // }

  // static getLoginSkipped() async {
  //   return Utilities.getPreference('IS_SKIPPED');
  // }

  // static clearAllPreference() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.clear();
  // } // used

  // static getPreference(key) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   return preferences.getString(key);
  // } // used

  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  // static const double BannerAspectRatio = 2.6;
  // static const double PromotionAspectRatio = 2.5;
  // static const double CategoryLandscapeAspectRatio = 2.5;
  // static const double CategoryPortraitAspectRatio = 0.85;
  // static const double CategoryLandscapeSmallAspectRatio = 1.7;

  // static calculateCategoryBanner(length) {
  //   Map<String, int> _result = {'base': 0, 'balance': 0};
  //   _result['base'] = (length / 4).floor();
  //   _result['balance'] = length - (_result['base'] * 4);
  //   return _result;
  // }

  // static showAlertDialogForLogin(
  //     BuildContext context, String title, String msg) {
  //   // set up the buttons
  //   Widget cancelButton = TextButton(
  //     child: Text("Cancel"),
  //     onPressed: () {
  //       Navigator.of(context, rootNavigator: true).pop();
  //     },
  //   );
  // Widget continueButton = TextButton(
  //   child: Text("Yes"),
  //   onPressed: () async {
  //     Navigator.of(context, rootNavigator: true).pop();
  //     await Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
  //   },
  // );

  // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text(title),
  //     content: Text(msg),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;

  //     },
  //   );
  // }

//   static String phoneNoValidator(String value) {
//     final validCharacters = RegExp(r'^[0-9]');
//     if (value.isEmpty) {
//       return 'Please enter PhoneNumber';
//     } else if (validCharacters.hasMatch(value) == false) {
//       return 'No Special Characters';
//     }
//     return null;
//   }

//   static String phoneNoValidatorOnlyIfPresent(String value) {
//     final validCharacters = RegExp(r'^(\+?6?01)[0-46-9]-*[0-9]{7,8}$');
//     if (value.isEmpty) {
//       return null;
//     } else if (validCharacters.hasMatch(value) == false) {
//       return 'Please enter only numeric characters!';
//     }
//     return null;
//   }

//   static String emailValidator(String value) {
//     if (value.isEmpty) return 'Please enter email';
//     Pattern pattern =
//         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//     RegExp regex = new RegExp(pattern);
//     if (!regex.hasMatch(value))
//       return 'Enter Valid Email';
//     else
//       return null;
//   }

//   static void openBrowser(String url) async{
//     await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
//   }

//   static int getColorFromHex(String hexColor) {
//     hexColor = hexColor.toUpperCase().replaceAll("#", "");
//     if (hexColor.length == 6) {
//       hexColor = "FF" + hexColor;
//     }
//     return int.parse(hexColor, radix: 16);
//   }

//   static String passwordValidator(String value) {
//     if (value.isEmpty) {
//       return 'Please enter Password';
//     }
//     return null;
//   }

//   static final Random _random = Random.secure();

//   static String createCryptoRandomString([int length = 32]) {
//     var values = List<int>.generate(length, (i) => _random.nextInt(256));

//     return base64Url.encode(values);
//   }

//   static Widget pageBusyIndicator() {
//     return Container(
//       child: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }

// enum ProductType {
//   NewArrivals,
//   Category,
//   HomeCategories,
//   Favorites,
//   Search,
//   Seller,
//   HomeCooking,
//   Restaurants,
// }

// enum gender { Male, Female }

}
