import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_e_commerce_shop_app/data/api/api_client.dart';
import 'package:flutter_e_commerce_shop_app/models/place_order.dart';

import 'package:flutter_e_commerce_shop_app/uitls/app_constants.dart';

class WishListRepo {
  final ApiClient apiClient;
  WishListRepo({required this.apiClient});

  Future<Response> getWishList() async {
    return await apiClient.getData(AppConstants.WISH_LIST_GET_URI);
  }

  Future<Response> addWishList(int id, bool isRestaurant) async {
    return await apiClient.postData('${AppConstants.ADD_WISH_LIST_URI}${'food_id='}$id', null);
  }

  Future<Response> removeWishList(int id, bool isRestaurant) async {
    print('${AppConstants.REMOVE_WISH_LIST_URI}food_id=$id');

    return await apiClient.deleteData(
        AppConstants.REMOVE_WISH_LIST_URI,
        query: {'food_id': id.toString()},
    );
  }
}
