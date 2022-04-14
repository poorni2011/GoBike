class GetSingleServiceDataModel {
  int? id;
  String? name;
  int? mainServiceId;
  String? image;
  int? amount;
  String? bannerImage;
  String? description;
  String? strikeAmount;
  int? status;
  // Null? deletedAt;
  String? createdAt;
  String? updatedAt;

  GetSingleServiceDataModel(
      {this.id,
        this.name,
        this.mainServiceId,
        this.image,
        this.amount,
        this.bannerImage,
        this.description,
        this.strikeAmount,
        this.status,
        // this.deletedAt,
        this.createdAt,
        this.updatedAt});

  GetSingleServiceDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mainServiceId = json['main_service_id'];
    image = json['image'];
    amount = json['amount'];
    bannerImage = json['banner_image'];
    description = json['description'];
    strikeAmount = json['strike_amount'];
    status = json['status'];
    // deletedAt = json['deleted_at'];
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
    data['banner_image'] = this.bannerImage;
    data['description'] = this.description;
    data['strike_amount'] = this.strikeAmount;
    data['status'] = this.status;
    // data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}