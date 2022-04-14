class GetServiceDataModel {
  int? id;
  String? title;
  String? image;
  String? description;
  int? serviceId;
  // Null deletedAt;
  String? createdAt;
  String? updatedAt;
  List<Services>? services;

  GetServiceDataModel(
      {this.id,
      this.title,
      this.image,
      this.description,
      this.serviceId,
      // this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.services});

  GetServiceDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    serviceId = json['service_id'];
    // deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['service_id'] = this.serviceId;
    // data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  int? id;
  String? name;
  int? mainServiceId;
  String? image;
  int? amount;
  String? strikeAmount;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? status;

  Services(
      {this.id,
      this.name,
      this.mainServiceId,
      this.image,
      this.amount,
      this.strikeAmount,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.status});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mainServiceId = json['main_service_id'];
    image = json['image'];
    amount = json['amount'];
    strikeAmount = json['strike_amount'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
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
    data['status'] = this.status;
    return data;
  }
}