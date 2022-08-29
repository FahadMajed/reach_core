import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:reach_auth/providers/providers.dart';
import 'package:reach_core/core/core.dart';

class NotificationsRepository {
  final Reader read;
  final NotificationsSource? source;

  NotificationsRepository(this.source, this.read);

  Future<void> subscribeToResearch(String researchId) async {
    await source!.subscribeToTopic(researchId);
  }

  Future<void> unsubscribeFromResearch(String researchId) async {
    await source!.unsubscribeFromTopic(researchId);
  }

  Future<void> subscribeToChat(String chatId) async {
    await source!.subscribeToTopic(chatId);
  }

  Future<void> setDeviceToken() async {
    try {
      final token = await source!.getDeviceToken();

      await read(databasePvdr)
          .collection(read(userCollectionPvdr))
          .doc(read(userIdPvdr))
          .update({'token': token});
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
    }
  }

  Future<bool> isPermissionDetermined() async =>
      await source!.isPermissionDetermined();

  Future<void> requestPermission() async => await source!.requestPermission();
}

final notificationsRepoPvdr = Provider<NotificationsRepository?>((ref) =>
    NotificationsRepository(ref.read(notificationsSourcePvdr), ref.read));
