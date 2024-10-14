// lib/features/notes/presentation/add_note_page.dart
import 'package:caretutors/features/notes/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/notes_provider.dart';
import '../../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class AddNotePage extends ConsumerStatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends ConsumerState<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  bool isLoading = false;
  String? error;

  Future<void> _addNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception('User not authenticated');

      await ref.read(notesRepositoryProvider).addNote(
            user.uid,
            Note(
              id: '',
              title: title,
              description: description,
            ),
          );

      context.pop(); // Navigate back to Home
    } catch (e) {
      setState(() {
        error = 'Failed to add note: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _cancel() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (error != null)
                Text(
                  error!,
                  style: TextStyle(color: Colors.red),
                ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => (value == null || value.isEmpty) ? 'Enter a title' : null,
                onChanged: (value) => title = value.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (value) => (value == null || value.isEmpty) ? 'Enter a description' : null,
                onChanged: (value) => description = value.trim(),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _addNote,
                          child: Text('Save'),
                        ),
                        ElevatedButton(
                          onPressed: _cancel,
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
