import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../data/model/notes.dart';
import '../../../utils/notification_service.dart';
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
  bool _setReminder = false;
  DateTime? _reminderDate;
  TimeOfDay? _reminderTime;

  // Pick date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _reminderDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _reminderDate = picked);
    }
  }

  // Pick time
  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  DateTime? get _combinedReminderDateTime {
    if (_reminderDate == null || _reminderTime == null) return null;
    return DateTime(
      _reminderDate!.year,
      _reminderDate!.month,
      _reminderDate!.day,
      _reminderTime!.hour,
      _reminderTime!.minute,
    );
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? "");
    bodyController = TextEditingController(text: widget.note?.body ?? "");

    // Prefill reminder if it exists
    if (widget.note?.reminderDate != null) {
      _setReminder = true;
      _reminderDate = widget.note!.reminderDate;
      _reminderTime = TimeOfDay.fromDateTime(widget.note!.reminderDate!);
    }
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.save, size: 40.0),
              onPressed:
                  createNotesViewModel.isLoading
                      ? null
                      : () async {
                        if (_setReminder) {
                          if (_reminderDate == null || _reminderTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a date and time"),
                              ),
                            );
                            return;
                          }
                        }
                        final updatedNote = widget.note?.copyWith(
                          title: titleController.text,
                          body: bodyController.text,
                          reminderDate:
                              _setReminder ? _combinedReminderDateTime : null,
                          clearReminder: !_setReminder,
                        );

                        await noteBaseViewModel.updateNote(
                          updatedNote!,
                          userId,
                        );

                        if (noteBaseViewModel.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(noteBaseViewModel.errorMessage!),
                            ),
                          );
                        } else {
                          // After successfully saving updating note to Firestore, reschedule notification
                          if (updatedNote.reminderDate != null) {
                            await NotificationService.instance
                                .rescheduleNotification(updatedNote);
                          } else {
                            await NotificationService.instance
                                .cancelNotificationByNoteId(updatedNote.id);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Note updated")),
                          );
                          context.pop();
                        }
                      },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: "Body"),
              maxLines: null,
              minLines: 6,
            ),

            const SizedBox(height: 20),
            // Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Set Reminder",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Switch(
                  value: _setReminder,
                  onChanged: (val) {
                    setState(() => _setReminder = val);
                  },
                ),
              ],
            ),

            if (_setReminder) ...[
              const SizedBox(height: 16),
              // Date selector
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickDate(context),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _reminderDate != null
                                  ? DateFormat.yMMMd().format(_reminderDate!)
                                  : "Select Date",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Time selector
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _reminderTime != null
                                  ? _reminderTime!.format(context)
                                  : "Select Time",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Icon(Icons.access_time, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// class EditNoteScreen extends StatefulWidget {
//   final Note? note;
//   const EditNoteScreen({super.key, required this.note});
//
//   @override
//   State<EditNoteScreen> createState() => _EditNoteScreenState();
// }
//
// class _EditNoteScreenState extends State<EditNoteScreen> {
//   late TextEditingController titleController;
//   late TextEditingController bodyController;
//   bool _setReminder = false;
//   DateTime? _reminderDate;
//   TimeOfDay? _reminderTime;
//
//   // Pick date
//   Future<void> _pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _reminderDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() => _reminderDate = picked);
//     }
//   }
//
//   // Pick time
//   Future<void> _pickTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _reminderTime ?? TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() => _reminderTime = picked);
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     titleController = TextEditingController(text: widget.note?.title);
//     bodyController = TextEditingController(text: widget.note?.body);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final createNotesViewModel = context.watch<CreateNotesViewmodel>();
//     final noteBaseViewModel = context.watch<NotesBaseViewmodel>();
//     final userId = FirebaseAuth.instance.currentUser!.uid;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Note"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save, size: 20.0, weight: 2),
//             onPressed:
//                 createNotesViewModel.isLoading
//                     ? null
//                     : () async {
//                       final updatedNote = widget.note?.copyWith(
//                         title: titleController.text,
//                         body: bodyController.text,
//                       );
//                       await noteBaseViewModel.updateNote(updatedNote!, userId);
//                       if (noteBaseViewModel.errorMessage != null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(createNotesViewModel.errorMessage!),
//                           ),
//                         );
//                       }
//                       if (noteBaseViewModel.errorMessage == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Note updated")),
//                         );
//                       }
//                       context.pop();
//                     },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: titleController,
//                     decoration: const InputDecoration(labelText: "Title"),
//                   ),
//                   const SizedBox(height: 12),
//                   Expanded(
//                     child: TextField(
//                       controller: bodyController,
//                       decoration: const InputDecoration(labelText: "Body"),
//                       maxLines: null,
//                       expands: true,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//             // Toggle
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Set Reminder",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 Switch(
//                   value: _setReminder,
//                   onChanged: (val) {
//                     setState(() => _setReminder = val);
//                   },
//                 ),
//               ],
//             ),
//
//             if (_setReminder) ...[
//               const SizedBox(height: 16),
//
//               //Date selector
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => _pickDate(context),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 14,
//                           horizontal: 12,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               _reminderDate != null
//                                   ? DateFormat.yMMMd().format(_reminderDate!)
//                                   : "Select Date",
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                             const Icon(
//                               Icons.calendar_today,
//                               color: Colors.grey,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => _pickTime(context),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 14,
//                           horizontal: 12,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               _reminderTime != null
//                                   ? _reminderTime!.format(context)
//                                   : "Select Time",
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                             const Icon(Icons.access_time, color: Colors.grey),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
