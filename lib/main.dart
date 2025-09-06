import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notely/domain/base_repository.dart';
import 'package:notely/presentation/home/home_viewmodel.dart';
import 'package:notely/presentation/login/login_viewmodel.dart';
import 'package:notely/presentation/notes/create_notes_viewmodel.dart';
import 'package:notely/presentation/notes/notes_base_viewmodel.dart';
import 'package:notely/presentation/onboarding/onboarding_screen.dart';
import 'package:notely/presentation/onboarding/sign_up_viewmodel.dart';
import 'package:notely/presentation/settings/theme_notifier.dart';
import 'package:notely/utils/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/di/service_locator.dart';
import 'domain/user_repository.dart';
import 'firebase_options.dart';
import 'navigation/app_router.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupServiceLocator();
  await NotificationService.instance.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    return MultiProvider(
      providers: [
        // Add your providers here
        ChangeNotifierProvider<SignUpViewmodel>(
          create: (_) => getIt<SignUpViewmodel>(),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create: (_) => getIt<LoginViewModel>(),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => getIt<HomeViewModel>(),
        ),
        ChangeNotifierProvider<CreateNotesViewmodel>(
          create: (_) => getIt<CreateNotesViewmodel>(),
        ),
        ChangeNotifierProvider<NotesBaseViewmodel>(
          create: (_) => getIt<NotesBaseViewmodel>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'GoRouter Demo',
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
