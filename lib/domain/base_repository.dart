import '../data/model/notes.dart';

abstract class BaseRepository {
  Future<void> updateNote(Note note, String currentUserId);
  Future<void> deleteNote(String noteId, String currentUserId);
  Future<void> toggleFavorite(
    String noteId,
    String currentUserId,
    bool isFavorite,
  );
}
