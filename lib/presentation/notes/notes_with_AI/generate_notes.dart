import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../create_notes_viewmodel.dart';
import 'chatgpt_service.dart';
import 'chatgpt_service_mock.dart';

class GenerateAiScreen extends StatefulWidget {
  const GenerateAiScreen({super.key});

  @override
  State<GenerateAiScreen> createState() => _GenerateAiScreenState();
}

class _GenerateAiScreenState extends State<GenerateAiScreen> {
  final _titleController = TextEditingController();
  String _generatedText = "";
  bool _loading = false;
  final bool useMock = false;

  Future<void> _generateSummary() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a topic")));
      return;
    }

    setState(() => _loading = true);

    try {
      // Call your ChatGPT API
      final aiResponse =
          useMock
              ? await ChatGptServiceMock.generateNote(_titleController.text)
              : await ChatGptService.generateNote(_titleController.text);

      setState(() {
        _generatedText = aiResponse;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _rephrase() async {
    if (_generatedText.isEmpty) return;

    setState(() => _loading = true);

    try {
      final aiResponse = await ChatGptService.rephrase(_generatedText);
      setState(() {
        _generatedText = aiResponse;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveNote() async {
    final createNoteViewModel = context.read<CreateNotesViewmodel>();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    await createNoteViewModel.createNote(
      _titleController.text,
      _generatedText,
      userId,
      null, // no reminder
    );

    if (createNoteViewModel.errorMessage == null) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(createNoteViewModel.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate with AI")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Enter a topic",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _generateSummary,
              child:
                  _loading
                      ? const CircularProgressIndicator()
                      : const Text("Generate"),
            ),
            const SizedBox(height: 16),
            if (_generatedText.isNotEmpty) ...[
              Expanded(
                child: SingleChildScrollView(child: Text(_generatedText)),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _loading ? null : _rephrase,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Rephrase"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _saveNote,
                    icon: const Icon(Icons.save),
                    label: const Text("Save"),
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
