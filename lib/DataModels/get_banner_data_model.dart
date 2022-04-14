class GetBannerDataModel {
  int? id;
  String? image;
  int? status;
  String? goTo;
  String? serviceId;
  // Null deletedAt;
  String? createdAt;
  String? updatedAt;

  GetBannerDataModel(
      {this.id,
      this.image,
      this.status,
      this.goTo,
      this.serviceId,
      // this.deletedAt,
      this.createdAt,
      this.updatedAt});

  GetBannerDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    status = json['status'];
    goTo = json['go_to'];
    serviceId = json['service_id'];
    // deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['status'] = this.status;
    data['go_to'] = this.goTo;
    data['service_id'] = this.goTo;
    // data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}