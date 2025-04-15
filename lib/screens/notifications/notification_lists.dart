import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_e_commerce_shop_app/components/colors.dart';
import 'package:flutter_e_commerce_shop_app/controllers/notification_controller.dart';
import 'package:flutter_e_commerce_shop_app/routes/route_helper.dart';

class NotificationListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(color: AppColors.mainBlackColor)),
        backgroundColor: AppColors.mainColor,
        iconTheme: IconThemeData(color: AppColors.mainBlackColor),
      ),
      body: GetBuilder<NotificationController>(
        builder: (notificationController) {
          if (notificationController.notificationList.isEmpty) {
            return Center(child: Text('No notifications available.', style: TextStyle(color: AppColors.paraColor)));
          }

          return ListView.builder(
            itemCount: notificationController.notificationList.length,
            itemBuilder: (context, index) {
              var notification = notificationController.notificationList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: AppColors.buttonBackgroundColor,
                  elevation: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(RouteHelper.getOrderDetailsRoute(notification.data.orderId));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID: ${notification.id}',
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4), // Add some spacing
                                Text(
                                  'Order ID: ${notification.data.orderId.toString()}',
                                  style: TextStyle(
                                    color: AppColors.titleColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4), // Add some spacing
                                Text(
                                  notification.data.description.toString(),
                                  style: TextStyle(
                                    color: AppColors.titleColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8), // Add some spacing
                      Container(
                        width: 3,
                        height: 40, // Adjust the height as needed
                        color: AppColors.mainColor, // Set the color of the divider
                      ),
                      SizedBox(width: 8), // Add some spacing
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Call the method to delete the notification
                          notificationController.deleteNotification(index);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
