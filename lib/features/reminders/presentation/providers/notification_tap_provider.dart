import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationTapNotifier extends StateNotifier<String?> {
  NotificationTapNotifier() : super(null);

  void setPayload(String payload) => state = payload;
  void clear() => state = null;
}

/// StateNotifierProvider para actualizar la app
final notificationTapProvider =
    StateNotifierProvider<NotificationTapNotifier, String?>(
  (ref) => NotificationTapNotifier(),
);