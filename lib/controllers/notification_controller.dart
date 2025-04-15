
import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';

import '../data/api/api_checker.dart';
import 'package:get/get.dart';

import '../data/repos/notification_repo.dart';
import '../helper/app_date_converter.dart';
import '../models/notification_model.dart';
class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});

  List<NotificationModel> _notificationList=[];
  List<NotificationModel> get notificationList => _notificationList;

  Future<int> getNotificationList(bool reload) async {
    if(_notificationList.isEmpty || reload) {
      Response response = await notificationRepo.getNotificationList();
      if (response.statusCode == 200) {
        _notificationList = [];

        response.body.forEach((notification) => _notificationList.add(NotificationModel.fromJson(notification)));
        _notificationList.sort((a, b) {
          return DateConverter.isoStringToLocalDate(a.updatedAt).compareTo(DateConverter.isoStringToLocalDate(b.updatedAt));

        });
        Iterable iterable = _notificationList.reversed;
        _notificationList = iterable.toList().cast<NotificationModel>();

      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
    return _notificationList.length;
  }

  void saveSeenNotificationCount(int count) {
    notificationRepo.saveSeenNotificationCount(count);
  }

  int? getSeenNotificationCount() {
    return notificationRepo.getSeenNotificationCount();
  }

  void clearNotification() {
    _notificationList = [];
  }

  // Add this method
  void deleteNotification(int index) async {
    int notificationId = _notificationList[index].id;
    // Assuming NotificationModel has an id field
    Response response = await notificationRepo.deleteNotification(notificationId);

    if (response.statusCode == 200) {
      _notificationList.removeAt(index);
      getNotificationList(true);
      update(); // Update the UI
    } else {

      ApiChecker.checkApi(response); // Handle API error
    }
  }

}
