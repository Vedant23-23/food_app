import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:flutter_e_commerce_shop_app/base/custom_snackbar.dart';
import 'package:flutter_e_commerce_shop_app/data/api/api_checker.dart';
import 'package:flutter_e_commerce_shop_app/data/repos/product_repo.dart';
import 'package:flutter_e_commerce_shop_app/data/repos/wish_list_repo.dart';
import 'package:flutter_e_commerce_shop_app/models/product.dart';
import 'package:get/get.dart';

class WishListController extends GetxController implements GetxService {
  final WishListRepo wishListRepo;
  final ProductRepo productRepo;

  WishListController({required this.wishListRepo, required this.productRepo});

  List<Product> _wishProductList = [];
  List<int> _wishProductIdList = [];
  List<int> _wishRestIdList = [];

  List<Product> get wishProductList => _wishProductList;

  List<int> get wishProductIdList => _wishProductIdList;

  List<int> get wishRestIdList => _wishRestIdList;

  void addToWishList(Product product, bool isRestaurant) async {
    Response response = await wishListRepo.addWishList(
        product.id, isRestaurant);
    if (response.statusCode == 200) {
      _wishProductList.add(product);
      _wishProductIdList.add(product.id);

      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void removeFromWishList(int id, bool isRestaurant) async {
    Response response = await wishListRepo.removeWishList(id, isRestaurant);
    if (response.statusCode == 200) {
      int _idIndex = -1;
      if (isRestaurant) {
        _idIndex = _wishRestIdList.indexOf(id);
        _wishRestIdList.removeAt(_idIndex);
      } else {
        _idIndex = _wishProductIdList.indexOf(id);
        _wishProductIdList.removeAt(_idIndex);
        _wishProductList.removeAt(_idIndex);
      }
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getWishList() async {
    _wishProductList = [];
    _wishProductIdList = [];
    Response response = await wishListRepo.getWishList();
    if (response.statusCode == 200) {
      var data = response.body;
      List products = data['products'];
      products.forEach((food) {
        Product product = Product.fromJson(food);

        _wishProductList.add(product);
        _wishProductIdList.add(product.id);
      });
      update();
    } else {
      print("----no wishlist ---");
    }
  }



/*  Future<void> getRecommendedProductList(bool reload) async {
    if(_recommendedProductList.isEmpty || reload) {

      Response response = await productRepo.getRecommendedProductList();
      if (response.statusCode == 200) {
        _recommendedProductList = [];
        _recommendedProductList.addAll(ProductModel.fromJson(response.body).products);
        //_popularPageSize = ProductModel.fromJson(response.body).totalSize;

        // print("product id is  "+ProductModel.fromJson(response.body).products.toString());
        _isLoadingRecommended = true;
        update();
      }else{
        showCustomSnackBar(response.statusText!);
      }

    }
  }*/
}
