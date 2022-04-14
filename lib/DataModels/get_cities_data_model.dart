class GetCitiesDataModel {
  int? id;
  String? name;
  int? stateMasterId;
  // Null? deletedAt;
  // Null? createdAt;
  // Null? updatedAt;
  int? activeStatus;

  GetCitiesDataModel(
      {this.id,
      this.name,
      this.stateMasterId,
      // this.deletedAt,
      // this.createdAt,
      // this.updatedAt,
      this.activeStatus});

  GetCitiesDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateMasterId = json['state_master_id'];
    // deletedAt = json['deleted_at'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    activeStatus = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_master_id'] = this.stateMasterId;
    // data['deleted_at'] = this.deletedAt;
    // data['created_at'] = this.createdAt;
    // data['updated_at'] = this.updatedAt;
    data['active_status'] = this.activeStatus;
    return data;
  }
}