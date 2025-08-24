import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:notely/data/model/notes.dart';
import 'package:notely/domain/base_repository.dart';

@LazySingleton()
class BaseRepositoryImpl implements BaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> deleteNote(String noteId, String currentUserId) async {
    try {
      await _firestore
          .collection('notes_table')
          .doc(currentUserId)
          .collection('notes')
          .doc(noteId)
          .delete();
    } catch (e) {
      throw Exception("Failed to delete note: $e");
    }
  }

  @override
  Future<void> updateNote(Note note, String currentUserId) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) throw Exception("No logged-in user");

      await _firestore
          .collection('notes_table')
          .doc(currentUserId)
          .collection('notes')
          .doc(note.id)
          .update(note.toMap());
    } catch (e) {
      throw Exception("Failed to update note: $e");
    }
  }

  @override
  Stream<List<Note>> streamNotes(String userId) {
    return _firestore
        .collection("notes_table")
        .doc(userId)
        .collection("notes")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Note(
              id: doc.id,
              title: data['title'] ?? '',
              body: data['body'] ?? '',
              createdAt: (data['createdAt'] as Timestamp).toDate(),
              updatedAt: (data['updatedAt'] as Timestamp).toDate(),
              userId: data['userId'] ?? '',
              isFavorite: data['isFavorite'] ?? false,
            );
          }).toList();
        });
  }

  @override
  Future<void> toggleFavorite(
    String noteId,
    String userId,
    bool isFavorite,
  ) async {
    try {
      final favorite = !isFavorite;
      await _firestore
          .collection("notes_table")
          .doc(userId)
          .collection("notes")
          .doc(noteId)
          .update({'isFavorite': favorite});
    } catch (e) {
      throw Exception("Failed to update note: $e");
    }
  }
}
