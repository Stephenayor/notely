// import 'package:flutter/material.dart';
// import 'package:notely/data/model/notes.dart';
//

//
// class HomeViewModel extends ChangeNotifier {
//   bool fabOpen = false;
//   int selectedFilterIndex = 0;
//   String searchQuery = "";
//   bool isLoading = false;
//   String? errorMessage;
//   final List<String> filters = ['All', 'Work', 'Favorites', 'Newest'];
//
//   final List<NoteItem> notes = List.generate(
//     8,
//     (i) => NoteItem(
//       title:
//           [
//             'Cashflow Notes',
//             'Meeting Internal',
//             'Building Company',
//             'UI/UX Tips',
//             'Hidden Key',
//             'Copywriting',
//             'Design Drafts',
//             'Product Notes',
//           ][i % 8],
//       snippet:
//           'To ensure a productive meeting, please confirm your availability for the following schedule: Kick-off Meeting: Monday, 10 AM...',
//       date: '2025/10/02',
//       time: '13:00',
//       locked: i % 3 == 0,
//     ),
//   );
//
//   void toggleFab() {
//     fabOpen = !fabOpen;
//     notifyListeners();
//   }
//
//   void selectedFilter(int index) {
//     selectedFilterIndex = index;
//     notifyListeners();
//   }
//
//   void updateSearch(String query) {
//     searchQuery = query;
//     notifyListeners();
//   }
//
//   List<NoteItem> get filteredNotes {
//     List<NoteItem> result = notes;
//
//     // Apply filter logic
//     switch (selectedFilterIndex) {
//       case 1:
//         // Example: Folders (dummy filter)
//         result = result.where((n) => n.title.contains("Draft")).toList();
//         break;
//       case 2:
//         // Example: Favorites (dummy filter)
//         result = result.where((n) => !n.locked).toList();
//         break;
//       case 3:
//         result = [...result]..sort((a, b) => b.date.compareTo(a.date));
//         break;
//     }
//
//     // Apply search filter
//     if (searchQuery.isNotEmpty) {
//       result =
//           result
//               .where(
//                 (n) =>
//                     n.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
//                     n.snippet.toLowerCase().contains(searchQuery.toLowerCase()),
//               )
//               .toList();
//     }
//
//     return result;
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notely/data/model/notes.dart';
import 'package:notely/domain/note_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  List<String> filters = ["All", "Work", "Personal", "Ideas"];
  int selectedFilterIndex = 0;
  String _searchQuery = '';

  Future<void> getNotes() async {
    final user = _auth.currentUser;
    if (user == null) {
      errorMessage = "User not logged in";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // _notes = await _noteRepository.getNotes(user.uid);
      _applyFilters();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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
                  ? true
                  : note.title.toLowerCase() ==
                      filters[selectedFilterIndex].toLowerCase();

          return matchesSearch && matchesFilter;
        }).toList();
  }
}
