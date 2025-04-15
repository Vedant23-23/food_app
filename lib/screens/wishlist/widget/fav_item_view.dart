
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_e_commerce_shop_app/controllers/wish_list_controller.dart';
import 'package:flutter_e_commerce_shop_app/routes/route_helper.dart';
import 'package:flutter_e_commerce_shop_app/uitls/app_constants.dart';
import 'package:flutter_e_commerce_shop_app/uitls/app_dimensions.dart';
import 'package:flutter_e_commerce_shop_app/widgets/big_text.dart';
import 'package:flutter_e_commerce_shop_app/widgets/icon_text_widget.dart';
import 'package:flutter_e_commerce_shop_app/widgets/text_widget.dart';

class FavItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<WishListController>(builder: (wishController) {
        if (wishController.wishProductList.isEmpty) {
          return  Center(child: Image.asset("img/wishlist.png", width: Dimensions.SPLASH_IMG_WIDTH));

        }
        return RefreshIndicator(
          onRefresh: () async {
            await wishController.getWishList();
          },
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: wishController.wishProductList.length,
            itemBuilder: (context, index) {
              var product = wishController.wishProductList[index];
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getPopularFoodRoute(index, "popular"));
                  },
                  child: Card(
                    elevation: 0.3, // Lowered the elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white, // Updated the background color to white
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: "${AppConstants.UPLOADS_URL}${product.img}",
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BigText(
                                  text: product.title,
                                  color: Colors.black87,
                                ),
                                SizedBox(height: 8),
                                TextWidget(
                                  text: '\$${product.price}',
                                  color: Colors.black54,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconAndTextWidget(
                                      icon: Icons.location_on,
                                      text: "1.7km",
                                      iconColor: Colors.red,
                                      color: Colors.black54,
                                    ),
                                    IconAndTextWidget(
                                      icon: Icons.access_time,
                                      text: "32min",
                                      iconColor: Colors.blue,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            
                             wishController.removeFromWishList(product.id, false);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
