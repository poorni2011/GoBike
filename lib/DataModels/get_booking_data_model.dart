class GetBooKingDataModel {
  int? id;
  int? userId;
  int? serviceId;
  String? bookingNumber;
  String? customerName;
  String? phone;
  String? email;
  String? address;
  String? pincode;
  String? city;
  String? state;
  String? country;
  String? landmark;
  int? bookingAddressId;
  String? vechicleName;
  String? vechicleNo;
  String? vechicleModel;
  String? complaintDetails;
  String? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Service? service;

  GetBooKingDataModel(
      {this.id,
      this.userId,
      this.serviceId,
      this.bookingNumber,
      this.customerName,
      this.phone,
      this.email,
      this.address,
      this.pincode,
      this.city,
      this.state,
      this.country,
      this.landmark,
      this.bookingAddressId,
      this.vechicleName,
      this.vechicleNo,
      this.vechicleModel,
      this.complaintDetails,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.service});

  GetBooKingDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    serviceId = json['service_id'];
    bookingNumber = json['booking_number'];
    customerName = json['customer_name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    pincode = json['pincode'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    landmark = json['landmark'];
    bookingAddressId = json['booking_address_id'];
    vechicleName = json['vechicle_name'];
    vechicleNo = json['vechicle_no'];
    vechicleModel = json['vechicle_model'];
    complaintDetails = json['complaint_details'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    service =
        json['service'] != null ? new Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['service_id'] = this.serviceId;
    data['booking_number'] = this.bookingNumber;
    data['customer_name'] = this.customerName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['landmark'] = this.landmark;
    data['booking_address_id'] = this.bookingAddressId;
    data['vechicle_name'] = this.vechicleName;
    data['vechicle_no'] = this.vechicleNo;
    data['vechicle_model'] = this.vechicleModel;
    data['complaint_details'] = this.complaintDetails;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    return data;
  }
}

class Service {
  int? id;
  String? name;
  int? mainServiceId;
  String? image;
  int? amount;
  String? strikeAmount;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Service(
      {this.id,
      this.name,
      this.mainServiceId,
      this.image,
      this.amount,
      this.strikeAmount,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mainServiceId = json['main_service_id'];
    image = json['image'];
    amount = json['amount'];
    strikeAmount = json['strike_amount'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['main_service_id'] = this.mainServiceId;
    data['image'] = this.image;
    data['amount'] = this.amount;
    data['strike_amount'] = this.strikeAmount;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}