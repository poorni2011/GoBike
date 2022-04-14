import 'dart:async';
import 'dart:io';

import 'package:bike_service_app/DataModels/get_banner_data_model.dart';
import 'package:bike_service_app/DataModels/get_cities_data_model.dart';
import 'package:bike_service_app/DataModels/get_service_data_model.dart';

import 'package:bike_service_app/common/ApiList.dart';
import 'package:bike_service_app/common/connectivity_check.dart';
import 'package:bike_service_app/screen/MainPage.dart';
import 'package:lottie/lottie.dart';
import 'package:bike_service_app/common/utilities.dart';
import 'package:bike_service_app/constants/colors_palette.dart';
import 'package:bike_service_app/constants/constants.dart';
import 'package:bike_service_app/screen/DescrPage.dart';
import 'package:bike_service_app/screen/GetVehicleInfo.dart';
import 'package:bike_service_app/screen/NoInternet.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'ComingSoonPage.dart';
import 'Registerpage.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? value;
  int activeStatus = 0;
  bool isLoading = true;
  bool isBannerLoading = true;

  static List<GetServiceDataModel> _getService = <GetServiceDataModel>[];

  static List<GetBannerDataModel> _getBanner = <GetBannerDataModel>[];

  Box box = Hive.box("API_BOX");

  getService() async {
    var client = http.Client();

    String token = await box.get(Constants.USER_TOKEN);
    try {
      final headers = {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token'
      };

      var url = Uri.parse(API.getService);

      var response = await http.get(url, headers: headers);
      print(jsonDecode(response.body));

      print('jsdksjkdjsk');

      if (response.statusCode == 200) {
        setState(() {
          _getService = jsonDecode(response.body)
              .map<GetServiceDataModel>(
                  (_item) => GetServiceDataModel.fromJson(_item))
              .toList();
        });

        // print(_getService[0].title.toString());
        if (_getService.isNotEmpty) {
          setState(() {
            isLoading = false;
          });
        } else {
          Utilities.showToast(context, 'Not Have');
          // Utilities.showToast('Nol have');
          // ToastUtilities().showToast("Not have");
        }
      } else {
        Utilities.showToast(context, response.body);
        // Utilities.showToast(response.body);
        // ToastUtilities().showToast(response.body);
      }
      setState(() {
        isLoading = false;
      });
    } on SocketException catch (e) {
      NoInternet();
      client.close();
      // ToastUtilities().showToast(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  getBanner() async {
    String token = await box.get(Constants.USER_TOKEN);
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(Uri.parse(API.getBanner), headers: headers);
    print("hjdfkjdk2");
    print("banner : ${jsonDecode(response.body)}");
    print("fhdjhjdh1");
    if (response.statusCode == 200) {
      setState(() {
        _getBanner = jsonDecode(response.body)
            .map<GetBannerDataModel>(
                (_item) => GetBannerDataModel.fromJson(_item))
            .toList();
         isBannerLoading = false;
      });
    }
  }

  String user = '';
  Future getUser() async {
    user = await box.get(Constants.USER_ID);

    setState(() {
      user = user;
    });
    print('Id :${user}');
  }

  //update
//   AppUpdateInfo? _updateInfo;
//   GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

//    Future<void> checkForUpdate() async {
//     InAppUpdate.checkForUpdate().then((info) {
//       setState(() {
//         _updateInfo = info;
//       });
//       print('error: $_updateInfo');
//     }).catchError((e) {
//       print('error : $e');
//       showSnack(e.toString());
//     });
//   }
// void showSnack(String text) {
//     if (_scaffoldKey.currentContext != null) {
//       ScaffoldMessenger.of(_scaffoldKey.currentContext!)
//           .showSnackBar(SnackBar(content: Text(text)));
//     }
//   }

  @override
  void initState() {
    super.initState();

   
    

    getUser();
    // _getPosition();
    getBanner();
    // position();
    getService();
    getCities();
    getInfo();
    checkInternet();
    
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
             behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 30.h,
        right: 20,
        left: 20),
            ));
  }

  // String? city;
  String? defaultCity;

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

        
        
      
      });
      box.put(Constants.DEFAULT_CITY, _getCities.first.name.toString());
    } else {
      Utilities.showToast(context, response.body);
    }
  }

  getInfo() async {
    selectedCity = await box.get(Constants.CITY_NAME);
    defaultCity = await box.get(Constants.DEFAULT_CITY);

    setState(() {
      selectedCity = selectedCity;
      defaultCity = defaultCity;
      print('defaultCity : $defaultCity');
    });
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            item,
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 17,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
  // selectCity() {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Container(
  //             height: 200,
  //             width: 200,
  //             child: Column(
  //               children: [
  //                 SizedBox(
  //                     height: 80,
  //                     width: 80,
  //                     child: Image.asset("assets/icons/marker.png")),
  //                 Text(
  //                   "Select Your City",
  //                   style: TextStyle(fontFamily: 'Poppins'),
  //                 ),
  //                 // DropdownButtonHideUnderline(
  //                 //   child: ButtonTheme(
  //                 //     alignedDropdown: true,
  //                 //     child: DropdownButton<String>(
  //                 //       value: data,
  //                 //       iconSize: 30,
  //                 //       icon: (null),
  //                 //       style: TextStyle(
  //                 //         color: Colors.black54,
  //                 //         fontSize: 16,
  //                 //       ),
  //                 //       hint: Text('Select City'),
  //                 //
  //                 //       onChanged: (newValue) {
  //                 //         setState(() {
  //                 //           data = newValue!;
  //                 //
  //                 //           print(data);
  //                 //         });
  //                 //       },
  //                 //
  //                 //       items: _getCities.map((item) {
  //                 //             return new DropdownMenuItem(
  //                 //               child: new Text(item.name.toString()),
  //                 //               value: item.id.toString()
  //                 //             );
  //                 //           }).toList(),
  //                 //     ),
  //                 //   ),
  //                 // ),
  //                 DropdownButtonHideUnderline(
  //                   child: DropdownButton<GetCitiesDataModel>(
  //                       hint: Padding(
  //                         padding: const EdgeInsets.only(left: 0),
  //                         child: Row(
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 2),
  //                               child: Text(
  //                                 'Select City',
  //                                 style: TextStyle(
  //                                   color: kPrimaryColor,
  //                                   fontSize: 19,
  //                                   fontWeight: FontWeight.w400,
  //                                   fontFamily: 'Poppins',
  //                                 ),
  //                               ),
  //                             ),
  //                             Icon(
  //                               Icons.arrow_drop_down,
  //                               color: kPrimaryColor,
  //                               size: 30,
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                       onChanged: (value){
  //                            setState(() {
  //                              cityName = value as List;
  //                            });
  //                       },
  //                       iconSize: 27,
  //                       icon: Visibility(
  //                           visible: false, child: Icon(Icons.arrow_downward)),
  //                       items: _getCities.map((item) {
  //                         return DropdownMenuItem(
  //                           child: child)
  //                       }).toList()
  //
  //                   )
  //
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  String? selectedCity;

  Future _showSelectCityDialog(context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                  "Select Your City",
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                Center(
                  child: Container(
                    width: 300,
                    child: DropdownButton(
                      hint: Text('Select City'), // Not necessary for Option 1
                      onChanged: (newValue) {
                        GetCitiesDataModel selctedData =
                            newValue as GetCitiesDataModel;
                        setState(() {
                          refresh();
                          // selectedCity = selctedData.name.toString();
                          box.put(
                              Constants.CITY_NAME, selctedData.name.toString());
                          box.put(Constants.CITY_ID, selctedData.id.toString());
                        });

                        selctedData.activeStatus == 1 ?
                        Navigator.pop(context)
                        : Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> ComingSoonCity()), (route) => false);
                      },
                      items: _getCities.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location.name.toString()),
                          value: location,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style:
                        TextStyle(color: kPrimaryColor, fontFamily: 'Poppins'),
                  ),
                ),
              ]);
            },
          ),
        );
      },
    );
  }

  

  Future refresh() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isLoading = false;
      getUser();
      // _getPosition();
      getBanner();
      // position();
      getService();
      getInfo();
      getCities();
    });
  }

  

   CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    print(_getService.length);
    print("lenfnfnfnfn");

    return  isInternetAvailable == true ?
    Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: (){
            _showSelectCityDialog(context);
          },
          child: Container(
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: kPrimaryColor,
                ),
                Text(
                 selectedCity == null ?
                    defaultCity == null ?
                    'Select City'
                    : defaultCity.toString()
                  : selectedCity.toString(),
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 20),
                ),
                Icon(
               Icons.keyboard_arrow_down,
                  color: kPrimaryColor,
            )
              ],
            ),
          ),
        ),
      ) ,
     
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0.0,
      //   automaticallyImplyLeading: false,
      //   title: GestureDetector(
      //     onTap: () {
      //       _showSelectCityDialog(context);
      //     },
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         Icon(
      //           Icons.location_on,
      //           color: kPrimaryColor,
      //         ),
      //         Text(
      //           selectedCity.toString(),
      //           style: TextStyle(
      //               color: kPrimaryColor,
      //               fontWeight: FontWeight.w500,
      //               fontFamily: 'Poppins',
      //               fontSize: 20),
      //         ),
      //       ],
      //     ),
      //   ),
      //   actions: [
      //     Icon(
      //        Icons.keyboard_arrow_down,
      //           color: kPrimaryColor,
      //     )
      //   ],
      // ),
      body: isLoading
          ?   Center(
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
              ),)
          : RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              backgroundColor: kPrimaryColor,
              color: Colors.white,
              strokeWidth: 3,
              displacement: 0,
              edgeOffset: 0,
              onRefresh: refresh,
              child: SingleChildScrollView(
                child:
                //  isLoading == false ?
                Container(
                  child: Column(
                    children: [
                      
                      CarouselSlider.builder(
                        carouselController: controller,
                          itemCount:
                              _getBanner.length != 0 ? _getBanner.length : 0,
                          itemBuilder: (BuildContext context, int i, int) {
                            return isBannerLoading == true 
                                ? Container(
                                    height: _height * 0.3,
                                    child: Center(
                                        child: CircularProgressIndicator()))
                                : GestureDetector(
                                    onTap: () {
                                      if (_getBanner[i].goTo == "1") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => DescrPage(
                                                      serviceid: _getBanner[i]
                                                          .serviceId
                                                          .toString(),
                                                    )));
                                      }
                                    },
                                    child: Container(

                                      child: FadeInImage(
                                        
                                        width: double.infinity,
                                       fit: BoxFit.fill,
                                        placeholder: 
                                         AssetImage("assets/bannerLoading.gif",
                                        
                                        ),
                                         image:  NetworkImage(
                                        Constants.default_img +
                                            _getBanner[i].image.toString(),),
                                        imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/bannerLoading.gif',
                            fit: BoxFit.fitWidth); }
                                      ),
                                    ),
                                  );
                          },
                          options: CarouselOptions(
                            onPageChanged: (index, reason){
                                  setState(() {
                                    activeStatus= index;
                                  });
                            },
                            height: _height * 0.33,
                            reverse: false,
                            autoPlay: true,
                            initialPage: 0,

                            viewportFraction: 1,
                          )),
                          SizedBox(height: 6,),
                          AnimatedSmoothIndicator(
                            
                            activeIndex: activeStatus,
                              count: _getBanner.length,
                              effect: ScrollingDotsEffect(
                                dotHeight: 6,
                                dotWidth: 6,
                                dotColor: Colors.grey,
                                activeDotColor: kPrimaryColor
                              ),
                              // effect: JumpingDotEffect(
                                
                              //   dotHeight: 6,
                              //   dotWidth: 6,
                              //   dotColor: Colors.grey,
                              //   activeDotColor: kPrimaryColor
                              // ),
                          ),
                         
                      !isLoading
                          ? SingleChildScrollView(
                              child: new ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _getService.length != 0
                                    ? _getService.length
                                    : 0,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Text(
                                              _getService[index]
                                                  .title
                                                  .toString(), //services
                                              style: new TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        // color: Colors.blue,
                                        padding: EdgeInsets.all(10),
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  crossAxisSpacing: 10),
                                          itemCount: _getService[index]
                                              .services!
                                              .length,
                                          itemBuilder: (context, i) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (_getService[index]
                                                          .services![i]
                                                          .status ==
                                                      1) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    DescrPage(
                                                                      serviceid: _getService[
                                                                              index]
                                                                          .services![
                                                                              i]
                                                                          .id!
                                                                          .toString(),
                                                                      // imgpath: Constants
                                                                      //         .default_img +
                                                                      //     _getService[index]
                                                                      //         .services![i]
                                                                      //         .image
                                                                      //         .toString(),
                                                                      // title:
                                                                      //     _getService[index]
                                                                      //         .services![i]
                                                                      //         .name
                                                                      //         .toString(),
                                                                      // amount:
                                                                      //     _getService[index]
                                                                      //         .services![i]
                                                                      //         .amount
                                                                      //         .toString(),
                                                                      // descr:
                                                                      //     _getService[index]
                                                                      //         .description
                                                                      //         .toString(),
                                                                      // strike_amount:
                                                                      //     _getService[index]
                                                                      //         .services![i]
                                                                      //         .strikeAmount
                                                                      //         .toString(),
                                                                    )));
                                                  } else {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ComingSoon()));
                                                  }
                                                },
                                                child: new Container(
                                                  height: 120,
                                                  // color: Colors.red,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 70,
                                                        height: 50,
                                                        child: Image.network(
                                                            Constants
                                                                    .default_img +
                                                                _getService[
                                                                        index]
                                                                    .services![
                                                                        i]
                                                                    .image
                                                                    .toString()),
                                                      ),
                                                      // SizedBox(
                                                      //   height: 10,
                                                      // ),
                                                      Flexible(
                                                        child: Center(
                                                          child: Text(
                                                            '${_getService[index].services![i].name.toString()}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 150,
                                ),
                                Center(
                                  child: Container(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        'Loading...',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ],
                                  )),
                                ),
                              ],
                            )
                    ],
                  ),
                ) 
                
              //   : Center(
              // child: Column(
              //   children: [
              //     SizedBox(height: 20.h,),
              //     SizedBox(
              //           height: 10.h, width: 80.w,
              //           child:  Lottie.asset('assets/bike_ride.json',fit: BoxFit.cover)
              //           // CircularProgressIndicator(
              //           //   strokeWidth: 3,
              //           //   color: kPrimaryColor,
              //           // ),
              //         ),
              //         SizedBox(height: 26.h,),
              //         Text('Loading.....', style: TextStyle(
              //           fontFamily: 'Poppins',
              //           fontSize: 15.sp,
              //           fontWeight: FontWeight.bold
                        
              //         ),)
              //   ],
              // ),)
              ),
            ),
    )
    : NoInternet();
    // Scaffold(
      
    //          backgroundColor: kPrimaryColor,
    //     //  appBar: AppBar(
    //     //    backgroundColor: kPrimaryColor,
    //     //    title: Text('Network Error'),
    //     //  ),
    //     body: Center(
    //       child: Container(
            
    //         child: Column(
    //           children: [
    //             SizedBox(height: 9.h,
    //             ),
    //             Container(
    //               width: double.infinity,
    //                 decoration: BoxDecoration(
    //                     color: Colors.white,
                        
    //                 ),
    //                 child: Lottie.asset('assets/no_internet.json',)),
    //             SizedBox(height: 4.h,),
    //             Text('No Internet Connection', style: TextStyle(
    //                 fontFamily: "Poppins",
    //                 color: Colors.white,
    //                 fontSize: 18,
    //                 fontWeight: FontWeight.w600),),

    //             SizedBox(height: 1.h,),
    //             Text('Please check your internet connection', style: TextStyle(
    //                 fontFamily: "Poppins",
    //                 color: Colors.white,
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.w400),),
    //             SizedBox(height: 5.h,),
    //             GestureDetector(
    //               onTap: (){
    //                   checkInternet();
    //                   print('ugjhj');
    //               },
    //               child: Container(
    //                 height: 40, width: 170,
    //                 decoration: BoxDecoration(
    //                     border: Border.all(color: kPrimaryColor),
    //                     color: Colors.white,
    //                     borderRadius: BorderRadius.circular(20)),
    //                 child: Center(
    //                   child: Text("Try again", style: TextStyle(color: kPrimaryColor,
    //                       fontWeight: FontWeight.w500,

    //                       fontSize: 16,
    //                       fontFamily: 'Poppins'),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     )
    // );
   
  }
}

Container _serviceContainer(String iconpath, String text) {
  return Container(
    width: 80,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(height: 40, width: 40, child: Image.asset(iconpath)),
        SizedBox(
          height: 6,
        ),
        Padding(
            padding: const EdgeInsets.only(
              left: 4,
            ),
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  color: kIconTextColor,
                  fontSize: 12),
            )),
      ],
    ),
  );
}


class ComingSoonCity extends StatefulWidget {
  const ComingSoonCity({ Key? key }) : super(key: key);

  @override
  _ComingSoonCityState createState() => _ComingSoonCityState();
}

class _ComingSoonCityState extends State<ComingSoonCity> {


  Box box = Hive.box("API_BOX");
  


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
      
      });
    } else {
      Utilities.showToast(context, response.body);
    }
  }
  

  getInfo() async {
    selectedCity = await box.get(Constants.CITY_NAME);
    setState(() {
      selectedCity = selectedCity;
    });
  }

    Future refresh() async {
    // setState(() {
    //   isLoading = true;
    // });

    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // isLoading = false;
      // getUser();
        
      // getBanner();
           
      // getService();
      getInfo();
      getCities();
    });
  }
  
   String? selectedCity;

  Future _showSelectCityDialog(context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                  "Select Your City",
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                Center(
                  child: Container(
                    width: 300,
                    child: DropdownButton(
                      hint: Text('Select City'), // Not necessary for Option 1
                      onChanged: (newValue) {
                        GetCitiesDataModel selctedData =
                            newValue as GetCitiesDataModel;
                        setState(() {
                         refresh();
                          // selectedCity = selctedData.name.toString();
                          box.put(
                              Constants.CITY_NAME, selctedData.name.toString());
                          box.put(Constants.CITY_ID, selctedData.id.toString());
                        });

                        selctedData.activeStatus == 0 ?
                        Navigator.pop(context)
                        : Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MainPage()), (route) => false);
                      },
                      items: _getCities.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location.name.toString()),
                          value: location,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style:
                        TextStyle(color: kPrimaryColor, fontFamily: 'Poppins'),
                  ),
                ),
              ]);
            },
          ),
        );
      },
    );
  }

   DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            item,
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 17,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCities();
    getInfo();
  }
 
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: (){
            _showSelectCityDialog(context);
          },
          child: Container(
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: kPrimaryColor,
                ),
                Text(
                selectedCity== null ?
                'Select City'
               : selectedCity.toString(),
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 20),
                ),
                Icon(
               Icons.keyboard_arrow_down,
                  color: kPrimaryColor,
            )
              ],
            ),
          ),
        ),
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
                    height: 190,
                    width: 190,
                    child: Image.asset("assets/icons/coming_soon.png")),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Coming soon...",
                style: TextStyle(
                    
                    fontSize: 18.sp,
                    
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              
            ],
          ),
        ),
      ),
    );
  }
}