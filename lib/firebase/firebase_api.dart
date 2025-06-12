import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Request permission from the user
    await _firebaseMessaging.requestPermission();

    // Get the device token
    final fcmToken = await _firebaseMessaging.getToken();

    // Corrected print statement
    print('FCM Token: $fcmToken');
  }
}
