import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/model/notes.dart';
import '../create_notes_viewmodel.dart';
import '../notes_base_viewmodel.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? note;
  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController bodyController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title);
    bodyController = TextEditingController(text: widget.note?.body);
  }

  @override
  Widget build(BuildContext context) {
    final createNotesViewModel = context.watch<CreateNotesViewmodel>();
    final noteBaseViewModel = context.watch<NotesBaseViewmodel>();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed:
                createNotesViewModel.isLoading
                    ? null
                    : () async {
                      final updatedNote = widget.note?.copyWith(
                        title: titleController.text,
                        body: bodyController.text,
                      );
                      await noteBaseViewModel.updateNote(updatedNote!, userId);
                      if (noteBaseViewModel.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(createNotesViewModel.errorMessage!),
                          ),
                        );
                      }
                      if (noteBaseViewModel.errorMessage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Note updated")),
                        );
                      }
                      context.pop();
                    },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: "Body"),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
