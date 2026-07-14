import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'driver_service.dart';
import 'session_service.dart';

class NotificationService {
  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  final DriverService _driverService =
      DriverService();

  final SessionService _sessionService =
      SessionService();

  Future<void> initialize() async {
    NotificationSettings settings =
        await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("========= NOTIFICATION =========");
    debugPrint(
      "Permission = ${settings.authorizationStatus}",
    );

    final token = await _messaging.getToken();

    debugPrint("FCM TOKEN:");
    debugPrint(token);

    if (token != null) {
      await _saveToken(token);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen(
      (newToken) async {
        debugPrint("NEW TOKEN:");
        debugPrint(newToken);

        await _saveToken(newToken);
      },
    );

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("========== NEW MESSAGE ==========");
      debugPrint(message.notification?.title);
      debugPrint(message.notification?.body);
    });
  }

  Future<void> _saveToken(String token) async {
    final userId =
        await _sessionService.getUserId();

    if (userId == null) {
      return;
    }

    final driverId =
        await _driverService.getDriverDocumentId(
      userId,
    );

    if (driverId == null) {
      return;
    }

    await _driverService.saveFcmToken(
      driverId: driverId,
      token: token,
    );

    debugPrint("FCM TOKEN SAVED");
  }
}