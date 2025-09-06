import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:notely/utils/notification_service.dart';
import 'package:provider/provider.dart';

import 'create_notes_viewmodel.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final createNoteViewModel = context.watch<CreateNotesViewmodel>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const SizedBox.shrink(),
        actions: [
          TextButton(
            onPressed:
                createNoteViewModel.isLoading
                    ? null
                    : () async {
                      final userId =
                          FirebaseAuth.instance.currentUser?.uid ?? '';
                      await createNoteViewModel.createNote(
                        _titleController.text,
                        _bodyController.text,
                        userId,
                        _setReminder ? _combinedReminderDateTime : null,
                      );

                      if (createNoteViewModel.errorMessage == null) {
                        context.pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(createNoteViewModel.errorMessage!),
                          ),
                        );
                      }
                    },
            child:
                createNoteViewModel.isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Title Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),

          // Body (fills remaining space)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _bodyController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Think on paper here...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),

          // ✅ Reminder Section (scrollable if long)
          _buildReminderSection(context),
        ],
      ),
    );
  }

  Padding _buildReminderSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
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
            GestureDetector(
              onTap: () => _pickDate(context),
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
                    const Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Time selector
            GestureDetector(
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
          ],
        ],
      ),
    );
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
}
