import 'package:notely/data/model/notes.dart';

abstract class NoteRepository {
  Future<void> saveNote(Note note, String currentUserId);
  Stream<List<Note>> getNotes(String userId);
  Future<void> updateNote(Note note, String currentUserId);
  Future<void> deleteNote(String noteId, String currentUserId);
}
