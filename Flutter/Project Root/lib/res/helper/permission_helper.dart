import 'package:permission_handler/permission_handler.dart';

bool isNotificationEnabled = false;

class PermissionHelper {
  static requestNotification() {
    Permission.notification.request().isGranted.then(
          (value) => isNotificationEnabled = value,
        );
  }
}
