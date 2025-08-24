import 'package:flutter/cupertino.dart';
import 'package:notely/domain/base_repository.dart';
import '../../data/model/notes.dart';

class NotesBaseViewmodel extends ChangeNotifier {
  final BaseRepository baseRepository;

  NotesBaseViewmodel(this.baseRepository);
  bool isLoading = false;
  String? errorMessage;
  String? toggleFavoriteErrorMessage;
  List<Note> notes = [];

  // Example methods:
  void setLoading(bool loading) {
    isLoading = loading;
  }

  void setError(String message) {
    errorMessage = message;
  }

  Future<void> updateNote(Note note, String userId) async {
    try {
      isLoading = true;
      notifyListeners();
      errorMessage = null;

      final updateNote = note.copyWith(updatedAt: DateTime.now());
      await baseRepository.updateNote(updateNote, userId);
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

      await baseRepository.deleteNote(noteId, userId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(
    String noteId,
    String userId,
    bool isFavorite,
  ) async {
    try {
      isLoading = true;
      notifyListeners();
      await baseRepository.toggleFavorite(noteId, userId, isFavorite);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Note> get favoriteNotes =>
      notes.where((note) => note.isFavorite).toList();
}
