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
}
