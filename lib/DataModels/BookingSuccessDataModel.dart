class BookingSucessDataModel {
  int? status;
  String? message;
  String? isFirst;

  BookingSucessDataModel({ this.status,  this.message, this.isFirst });

  BookingSucessDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isFirst = json['isFirst'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['isFirst'] = this.isFirst;
    return data;
  }
}