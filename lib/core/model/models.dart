class ResponseModel {
  int? customerId;
  String? latitude;
  String? longitude;
  List<Merchants>? merchants;
  List<String>? shopCategories;

  ResponseModel(
      {this.customerId,
        this.latitude,
        this.longitude,
        this.merchants,
        this.shopCategories});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['merchants'] != null) {
      merchants = <Merchants>[];
      json['merchants'].forEach((v) {
        merchants!.add(new Merchants.fromJson(v));
      });
    }
    shopCategories = json['shop_categories'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.merchants != null) {
      data['merchants'] = this.merchants!.map((v) => v.toJson()).toList();
    }
    data['shop_categories'] = this.shopCategories;
    return data;
  }
}

class Merchants {
  String? name;
  double? distance;
  List<String>? categories;

  Merchants({this.name, this.distance, this.categories});

  Merchants.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    distance = json['distance'];
    categories = json['categories'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['distance'] = this.distance;
    data['categories'] = this.categories;
    return data;
  }
}
