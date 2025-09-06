import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../data/model/notes.dart';
import '../../domain/note_repository.dart';
import '../../main.dart';
import '../../utils/notification_service.dart';

class CreateNotesViewmodel extends ChangeNotifier {
  final NoteRepository _noteRepository;
  bool isLoading = false;
  String? errorMessage;

  CreateNotesViewmodel(this._noteRepository);

  Future<void> createNote(
    String title,
    String body,
    String userId,
    DateTime? reminderDate,
  ) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final id = const Uuid().v4();
      final now = DateTime.now();

      final note = Note(
        id: id,
        title: title,
        body: body,
        createdAt: now,
        updatedAt: now,
        userId: userId,
        isFavorite: false,
        reminderDate: reminderDate,
      );
      // Create Local Notification
      if (note.reminderDate != null) {
        await NotificationService.instance.scheduleNotification(note);
        // await NotificationService.instance.zonedScheduleNotification(
        //   note.title,
        //   note.reminderDate!,
        //   "Reminder ${note.title}",
        // );
      }

      await _noteRepository.saveNote(note, userId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateNote(Note note, String userId) async {
    try {
      isLoading = true;
      notifyListeners();
      errorMessage = null;

      final updatedNote = note.copyWith(updatedAt: DateTime.now());
      await _noteRepository.updateNote(updatedNote, userId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteNote(String noteId, String userId) async {
    try {
      isLoading = true;
      notifyListeners();
      errorMessage = null;

      await _noteRepository.deleteNote(noteId, userId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
