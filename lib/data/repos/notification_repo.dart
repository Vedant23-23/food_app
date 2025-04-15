
import 'package:shared_preferences/shared_preferences.dart';

import '../../uitls/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';
class NotificationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  NotificationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getNotificationList() async {
    return await apiClient.getData(AppConstants.NOTIFICATION_URI);
  }

  void saveSeenNotificationCount(int count) {
    sharedPreferences.setInt(AppConstants.NOTIFICATION_COUNT, count);
  }

  int? getSeenNotificationCount() {
    return sharedPreferences.getInt(AppConstants.NOTIFICATION_COUNT);
  }
  // Add this method
  Future<Response> deleteNotification(int notificationId) async {
    print('${AppConstants.DELETE_NOTIFICATION_URI}?notification_id=$notificationId');
    return await apiClient.deleteData(
      AppConstants.DELETE_NOTIFICATION_URI,
      query: {'notification_id': notificationId.toString()},
    );
  }
}