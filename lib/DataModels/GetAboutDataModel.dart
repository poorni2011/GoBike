class GetAboutDataModel {
  int? id;
  String? appName;
  String? aboutUsContent;
  String? contactNumber;
  String? email;
  String? website;
  String? serviceNumber;
  String? activeStatus;
  String? bookingEnble;
  String? address;
  String? storeLocation;
  String? isFirstMsg;
  String? shareAppLinkContent;

  GetAboutDataModel(
      {this.id,
        this.appName,
        this.aboutUsContent,
        this.contactNumber,
        this.email,
        this.website,
        this.serviceNumber,
        this.activeStatus,
        this.bookingEnble,
        this.address,
        this.storeLocation,
        this.isFirstMsg,
        this.shareAppLinkContent});

  GetAboutDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appName = json['app_name'];
    aboutUsContent = json['about_us_content'];
    contactNumber = json['contact_number'];
    email = json['email'];
    website = json['website'];
    serviceNumber = json['service_number'];
    activeStatus = json['active_status'];
    bookingEnble = json['booking_enble'];
    address = json['address'];
    storeLocation = json['store_location'];
    isFirstMsg = json['is_first_msg'];
    shareAppLinkContent = json['share_app_link_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['app_name'] = this.appName;
    data['about_us_content'] = this.aboutUsContent;
    data['contact_number'] = this.contactNumber;
    data['email'] = this.email;
    data['website'] = this.website;
    data['service_number'] = this.serviceNumber;
    data['active_status'] = this.activeStatus;
    data['booking_enble'] = this.bookingEnble;
    data['address'] = this.address;
    data['store_location'] = this.storeLocation;
    data['is_first_msg'] = this.isFirstMsg;
    data['share_app_link_content'] = this.shareAppLinkContent;
    return data;
  }
}