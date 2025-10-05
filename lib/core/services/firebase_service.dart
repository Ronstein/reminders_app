import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reminders_app/config/config.dart';
import 'package:reminders_app/firebase_options.dart';

class FirebaseService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    if (!Environment.useFirebase) {
      debugPrint('FirebaseService: skipped (useFirebase=false)');
      return;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
      debugPrint('FirebaseService: initialized successfully.');
    } catch (e) {
      debugPrint('FirebaseService: init failed - $e');
    }
  }
}