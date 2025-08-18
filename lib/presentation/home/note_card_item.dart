import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notely/presentation/notes/notes_base_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../data/model/notes.dart';
import '../../utils/routes.dart';
import '../notes/create_notes_viewmodel.dart';

class NoteCardItem extends StatelessWidget {
  final Note note;

  const NoteCardItem({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final createNotesViewModel = context.read<CreateNotesViewmodel>();
    final noteBaseViewModel = context.read<NotesBaseViewmodel>();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    const borderRadius = 14.0;

    return GestureDetector(
      onTap: () {
        context.push(Routes.editNote, extra: note);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      note.body,
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed:
                          noteBaseViewModel.isLoading
                              ? null
                              : () async {
                                await noteBaseViewModel.deleteNote(
                                  note.id,
                                  userId,
                                );
                                if (noteBaseViewModel.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        noteBaseViewModel.errorMessage!,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (noteBaseViewModel.isLoading) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Deleting note..."),
                                    ),
                                  );
                                }
                                if (noteBaseViewModel.errorMessage == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Note deleted"),
                                    ),
                                  );
                                }
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(content: Text("Note deleted")),
                                // );
                              },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        note.createdAt.toLocal().toString().split(' ')[0],
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      Text(
                        '${note.createdAt.hour.toString().padLeft(2, '0')}:${note.createdAt.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
