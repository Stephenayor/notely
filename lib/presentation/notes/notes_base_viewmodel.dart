import 'package:flutter/cupertino.dart';
import 'package:notely/domain/base_repository.dart';
import '../../data/model/notes.dart';

class NotesBaseViewmodel extends ChangeNotifier{
  final BaseRepository baseRepository;

  NotesBaseViewmodel(this.baseRepository);
  bool isLoading = false;
  String? errorMessage;

  // Example methods:
  void setLoading(bool loading) {
    isLoading = loading;
  }

  void setError(String message) {
    errorMessage = message;
  }

  Future<void> updateNote(Note note, String userId) async {
    try{
      isLoading = true;
      notifyListeners();
      errorMessage = null;

      final updateNote = note.copyWith(updatedAt: DateTime.now());
      await baseRepository.updateNote(updateNote, userId);
    }catch(e){
      errorMessage = e.toString();
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteNote(String noteId, String userId) async {
    try{
      isLoading = true;
      notifyListeners();
      errorMessage = null;

      await baseRepository.deleteNote(noteId, userId);
    }catch(e){
      errorMessage = e.toString();
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }
}
