import 'package:get_it/get_it.dart';
import 'package:notely/data/repository/base_repository_impl.dart';
import 'package:notely/data/repository/note_repository_impl.dart';
import 'package:notely/data/repository/user_repository_impl.dart';
import 'package:notely/domain/base_repository.dart';
import 'package:notely/domain/note_repository.dart';
import 'package:notely/presentation/home/home_viewmodel.dart';
import 'package:notely/presentation/login/login_viewmodel.dart';
import 'package:notely/presentation/notes/create_notes_viewmodel.dart';
import 'package:notely/presentation/notes/notes_base_viewmodel.dart';
import 'package:notely/presentation/onboarding/sign_up_viewmodel.dart';
import '../../domain/user_repository.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register repository
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  getIt.registerLazySingleton<NoteRepository>(() => NoteRepositoryImpl());
  getIt.registerLazySingleton<BaseRepository>(() => BaseRepositoryImpl());

  // Register ViewModels
  getIt.registerFactory<SignUpViewmodel>(
    () => SignUpViewmodel(getIt<UserRepository>()),
  );

  getIt.registerFactory<LoginViewModel>(
    () => LoginViewModel(getIt<UserRepository>()),
  );

  getIt.registerFactory<HomeViewModel>(
    () => HomeViewModel(getIt<NoteRepository>()),
  );

  getIt.registerFactory<CreateNotesViewmodel>(
    () => CreateNotesViewmodel(getIt<NoteRepository>()),
  );

  getIt.registerFactory<NotesBaseViewmodel>(
    () => NotesBaseViewmodel(getIt<BaseRepository>()),
  );
}
