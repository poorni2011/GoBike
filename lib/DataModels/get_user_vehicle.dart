class GetVehicleDataModel {
  int? status;
  String? message;
  Vehicle? vehicle;

  GetVehicleDataModel({this.status, this.message, this.vehicle});

  GetVehicleDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    return data;
  }
}

class Vehicle {
  int? id;
  String? brandName;
  String? plateNo;
  String? isSingleOwner;
  String? yearOfPurchase;
  String? userId;
  String? image;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;

  Vehicle(
      {this.id,
      this.brandName,
      this.plateNo,
      this.isSingleOwner,
      this.yearOfPurchase,
      this.userId,
      this.image,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandName = json['brand_name'];
    plateNo = json['plate_no'];
    isSingleOwner = json['is_single_owner'];
    yearOfPurchase = json['year_of_purchase'];
    userId = json['user_id'];
    image = json['image'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brand_name'] = this.brandName;
    data['plate_no'] = this.plateNo;
    data['is_single_owner'] = this.isSingleOwner;
    data['year_of_purchase'] = this.yearOfPurchase;
    data['user_id'] = this.userId;
    data['image'] = this.image;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}