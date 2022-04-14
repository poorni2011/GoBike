class API{
  static String baseUrl = 'http://bikeservice.devopssoftsolutions.com';

  static String loginUrl = '$baseUrl/api/login';
  static String registerUrl = '$baseUrl/api/register';
  static String userUrl = '$baseUrl/api/user';
  static String addUserVehicleUrl = '$baseUrl/api/add-user-vehicle';
  static String getService = '$baseUrl/api/get-services';
  static String addService = '$baseUrl/api/add-service';
  static String removeService = '$baseUrl/api/remove-services/{id}';
  static String getServiceFeature ='$baseUrl/api/get-service-feature/{id}';
  static String addServiceFeature = '$baseUrl/api/add-service-feature';
  static String removeServiceFeature = '$baseUrl/api/remove-service-feature/{id}';
  static String addBooking = '$baseUrl/api/add-booking';
  static String getBooking = '$baseUrl/api/get-booking';
  static String userData = '$baseUrl/api/user';
   static String getCities = '$baseUrl/api/get-cities';
  static String checkUser = "$baseUrl/api/check-user";
  static String getUserVehicle = "$baseUrl/api/get-user-vehicle";
  static String getBanner = "$baseUrl/api/get-banner";
  static String getSingleService = "$baseUrl/api/get-service/";
  static String getAbout = "$baseUrl/api/get-about";
   static url() {
    return baseUrl;
  }
}