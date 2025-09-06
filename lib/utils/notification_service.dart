import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart' as ftz;
import 'package:notely/utils/constants.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:notely/data/model/notes.dart';
import 'dart:io' show Platform;

import '../main.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _flnp =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  FlutterLocalNotificationsPlugin get plugin => _flnp;

  /// Call this once in main() before runApp()
  Future<void> init() async {
    if (_initialized) return;

    // initialize timezone database
    tzdata.initializeTimeZones();

    // get the local timezone
    try {
      final String timeZoneName = await ftz.FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      tz.setLocalLocation(tz.local);
    }

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _flnp.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // TODO: handle navigation using response.payload if needed
      },
    );

    _initialized = true;
  }

  /// Request runtime notification permissions (Android 13+ / iOS)
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final bool? granted =
          await _flnp
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission();
      return granted ??
          true; // null means old Android version -> assume granted
    } else if (Platform.isIOS || Platform.isMacOS) {
      final bool? granted = await _flnp
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    return true;
  }

  /// Schedules a one-time notification
  Future<void> scheduleNotification(Note note) async {
    if (!_initialized) await init();
    if (note.reminderDate == null) return;

    final hasPermission = await _requestPermissions();
    if (!hasPermission) return;

    final scheduled = tz.TZDateTime.from(note.reminderDate!, tz.local);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;

    final androidDetails = AndroidNotificationDetails(
      Constants.NOTE_CHANNEL_ID,
      'Note Reminders',
      channelDescription: 'Reminder notifications for notes',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    final iosDetails = DarwinNotificationDetails();

    await _flnp.zonedSchedule(
      note.id.hashCode,
      note.title.isNotEmpty ? note.title : 'Note Reminder',
      note.body.isNotEmpty ? note.body : 'It’s time for your note',
      scheduled,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: note.id,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    );

    final pending = await _flnp.pendingNotificationRequests();
    if (kDebugMode) {
      print("Pending notifications: ${pending.length}");
    }
    for (var p in pending) {
      if (kDebugMode) {
        print(" → id=${p.id}, title=${p.title}, body=${p.body}");
      }
    }
  }

  Future<int> zonedScheduleNotification(
    String note,
    DateTime date,
    String occ,
  ) async {
    int id = math.Random().nextInt(10000);

    try {
      final scheduled = tz.TZDateTime.from(date, tz.local);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        occ,
        note,
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            Constants.NOTE_CHANNEL_ID,
            'Note Reminders',
            channelDescription: 'Reminder notifications for notes',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,

            icon: '@drawable/notification_bell',
          ),
          iOS: DarwinNotificationDetails(),
        ),

        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      return id;
    } catch (e) {
      log("Error at zonedScheduleNotification: $e");
      return -1;
    }
  }

  Future<void> cancelNotificationByNoteId(String noteId) async {
    if (!_initialized) await init();
    await _flnp.cancel(noteId.hashCode);
  }

  Future<void> rescheduleNotification(Note note) async {
    if (!_initialized) await init();
    await cancelNotificationByNoteId(note.id);
    if (note.reminderDate != null) {
      await scheduleNotification(note);
    }
  }

  Future<void> cancelAll() async {
    await _flnp.cancelAll();
  }
}
