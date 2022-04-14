class ServiceDataModel {
  int? id;
  String? name;
  int? mainServiceId;
  // Null image;
  int? amount;
  String? strikeAmount;


  ServiceDataModel(
      {this.id,
      this.name,
      this.mainServiceId,
      // this.image,
      this.amount,
      this.strikeAmount,
      });

  ServiceDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mainServiceId = json['main_service_id'];
    // image = json['image'];
    amount = json['amount'];
    strikeAmount = json['strike_amount'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['main_service_id'] = this.mainServiceId;
    // data['image'] = this.image;
    data['amount'] = this.amount;
    data['strike_amount'] = this.strikeAmount;
  
    return data;
  }
}