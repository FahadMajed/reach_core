import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsSource {
  final FirebaseMessaging? _fcm;

  NotificationsSource(
    this._fcm,
  );

  Future<String?> getDeviceToken() async => await _fcm!.getToken();

  Future<void> subscribeToTopic(String topic) async =>
      await _fcm!.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) async =>
      await _fcm!.unsubscribeFromTopic(topic);

  Future<bool> isPermissionDetermined() async {
    final notificationsSettings = await _fcm!.requestPermission(
      alert: false,
    );
    return notificationsSettings.authorizationStatus ==
        AuthorizationStatus.notDetermined;
  }

  Future<void> requestPermission() async =>
      await _fcm!.requestPermission(alert: true);
}
