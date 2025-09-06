import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/model/notes.dart';
import '../../utils/routes.dart';
import '../notes/notes_base_viewmodel.dart';

class NoteCardItem extends StatelessWidget {
  final Note note;

  const NoteCardItem({super.key, required this.note});

  Future<void> _deleteNote(
    BuildContext context,
    NotesBaseViewmodel noteBaseViewModel,
  ) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await noteBaseViewModel.deleteNote(note.id, currentUserId);

    if (noteBaseViewModel.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(noteBaseViewModel.errorMessage!)));
      return;
    }

    if (noteBaseViewModel.isLoading) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Deleting note...")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Note deleted")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteBaseViewModel = context.read<NotesBaseViewmodel>();
    const borderRadius = 14.0;
    final theme = Theme.of(context); // 👈 use theme

    return GestureDetector(
      onTap: () => context.push(Routes.editNote, extra: note),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor, // 👈 adapts to light/dark theme
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1), // 👈 dynamic shadow
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title + Favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Consumer<NotesBaseViewmodel>(
                    builder: (_, baseVm, __) {
                      return IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color:
                              note.isFavorite
                                  ? Colors.red
                                  : theme.iconTheme.color,
                        ),
                        onPressed:
                            baseVm.isLoading
                                ? null
                                : () async => await baseVm.toggleFavorite(
                                  note.id,
                                  FirebaseAuth.instance.currentUser!.uid,
                                  note.isFavorite,
                                ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Body
              Text(
                note.body,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Reminder
              if (note.reminderDate != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.alarm,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat.yMMMd().add_jm().format(note.reminderDate!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],

              // Dates + Delete button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.updatedAt.isAfter(note.createdAt)
                              ? 'Edited: ${DateFormat.yMMMd().format(note.updatedAt)}'
                              : DateFormat.yMMMd().format(note.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: theme.hintColor,
                          ),
                        ),
                        Text(
                          '${(note.updatedAt.isAfter(note.createdAt) ? note.updatedAt : note.createdAt).hour.toString().padLeft(2, '0')}:${(note.updatedAt.isAfter(note.createdAt) ? note.updatedAt : note.createdAt).minute.toString().padLeft(2, '0')}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: theme.colorScheme.error,
                      size: 26,
                    ),
                    onPressed:
                        noteBaseViewModel.isLoading
                            ? null
                            : () => _deleteNote(context, noteBaseViewModel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
