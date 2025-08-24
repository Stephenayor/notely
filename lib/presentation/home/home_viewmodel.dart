import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notely/data/model/notes.dart';
import 'package:notely/domain/note_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeViewModel extends ChangeNotifier {
  final NoteRepository _noteRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<List<Note>>? _notesSubscription;

  HomeViewModel(this._noteRepository);

  List<Note> _notes = [];
  List<Note> filteredNotes = [];
  bool isLoading = false;
  String? errorMessage;

  bool fabOpen = false;
  List<String> filters = ["All", "Favorites"];
  int selectedFilterIndex = 0;
  String _searchQuery = '';

  Future<void> listenToNotes() async {
    final user = _auth.currentUser;
    if (user == null) {
      errorMessage = "User not logged in";
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();

    _notesSubscription = _noteRepository
        .getNotes(user.uid)
        .listen(
          (notesList) {
            _notes = notesList;
            _applyFilters();
            isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            errorMessage = error.toString();
            isLoading = false;
            notifyListeners();
          },
        );
  }

  @override
  void dispose() {
    _notesSubscription?.cancel();
    super.dispose();
  }

  void updateSearch(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void selectedFilter(int index) {
    selectedFilterIndex = index;
    _applyFilters();
  }

  void toggleFab() {
    fabOpen = !fabOpen;
    notifyListeners();
  }

  void _applyFilters() {
    filteredNotes =
        _notes.where((note) {
          final matchesSearch =
              note.title.toLowerCase().contains(_searchQuery) ||
              note.title.toLowerCase().contains(_searchQuery);

          final matchesFilter =
              selectedFilterIndex == 0
                  ? true // All
                  : note.isFavorite; // Favorites only

          return matchesSearch && matchesFilter;
        }).toList();
    notifyListeners();
  }
}

class NoteItem {
  final String title;
  final String snippet;
  final String date;
  final String time;
  final bool locked;

  const NoteItem({
    required this.title,
    required this.snippet,
    required this.date,
    required this.time,
    this.locked = false,
  });
}
