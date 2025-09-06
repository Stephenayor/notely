import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:notely/data/model/notes.dart';
import 'package:notely/domain/note_repository.dart';

@lazySingleton
class NoteRepositoryImpl implements NoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> saveNote(Note note, String currentUserId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("No logged-in user");
      final notesFireStoreReference = _firestore
          .collection('notes_table')
          .doc(user.uid)
          .collection('notes');
      await notesFireStoreReference.doc(note.id).set(note.toMap());
    } catch (e) {
      throw Exception("Failed to save note: $e");
    }
  }

  @override
  Stream<List<Note>> getNotes(String userId) {
    try {
      return _firestore
          .collection('notes_table')
          .doc(userId)
          .collection('notes')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs
                    .map(
                      (doc) => Note.fromMap(doc.data() as Map<String, dynamic>),
                    )
                    .toList(),
          );
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  @override
  Future<void> updateNote(Note note, String currentUserId) async {
    try {
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
  Future<void> deleteNote(String noteId, String currentUserId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("No logged-in user");

      final notesFireStoreReference = _firestore
          .collection('notes_table')
          .doc(currentUserId)
          .collection('notes');

      await notesFireStoreReference.doc(noteId).delete();
    } catch (e) {
      throw Exception("Failed to delete note: $e");
    }
  }
}
