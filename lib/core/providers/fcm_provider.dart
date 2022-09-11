import 'package:reach_core/core/core.dart';

final notificationsSourcePvdr = Provider<NotificationsSource?>(
    (ref) => NotificationsSource(FirebaseMessaging.instance));
