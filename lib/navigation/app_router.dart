import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:notely/data/model/notes.dart';
import 'package:notely/presentation/login/login_screen.dart';
import 'package:notely/presentation/notes/create_notes_screen.dart';
import 'package:notely/presentation/notes/notes_with_AI/generate_notes.dart';
import 'package:notely/presentation/notes/update/edit_note_screen.dart';
import 'package:notely/presentation/settings/settings_screen.dart';
import 'package:notely/utils/routes.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/onboarding/onboarding_screen.dart';
import '../presentation/onboarding/sign_up_screen.dart';
import '../utils/success_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: Routes.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(path: Routes.home, builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.createNote,
      builder: (context, state) => const CreateNoteScreen(),
    ),
    GoRoute(
      path: Routes.editNote,
      builder: (context, state) {
        final note = state.extra as Note;
        return EditNoteScreen(note: note);
      },
    ),
    GoRoute(
      path: Routes.generateAIScreen,
      builder: (context, state) {
        return GenerateAiScreen();
      },
    ),
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: Routes.successScreen,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return SuccessScreen(
          title: extras['title'] as String,
          message: extras['message'] as String,
          primaryButtonText: extras['primaryButtonText'] as String,
          secondaryButtonText: extras['secondaryButtonText'] as String,
          primaryRoute: extras['primaryRoute'] as String?,
          secondaryRoute: extras['secondaryRoute'] as String?,
        );
      },
    ),
  ],
);
