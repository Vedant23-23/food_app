import 'package:get/get.dart';
import 'package:flutter_e_commerce_shop_app/data/api/api_client.dart';
import 'package:flutter_e_commerce_shop_app/models/product.dart';
import 'package:flutter_e_commerce_shop_app/uitls/app_constants.dart';

class ProductRepo extends GetxService {
  final ApiClient apiClient;
  ProductRepo({required this.apiClient});

  Future<Response> getRecommendedProductList() async {
   // print("I am repo.................");
    return await apiClient.getData(AppConstants.RECOMMENDED_PRODUCT_URI);
  }
  Future<Response> getPopularProductList() async {
    return await apiClient.getData(AppConstants.POPULAR_PRODUCT_URI);
  }

  Future<Response> getExtraProductList() async {
    return await apiClient.getData(AppConstants.EXTRA_PRODUCT_URI);
  }

}