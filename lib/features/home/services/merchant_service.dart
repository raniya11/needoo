import 'dart:convert';
import 'package:food_delivery_app/core/constants/api/api_dart.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static Future<ResponseModel> fetchProducts(String phoneNumber, double latitude, double longitude) async {
    final url = '${Api().baseUrl}$phoneNumber/$latitude/$longitude/';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      return ResponseModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
