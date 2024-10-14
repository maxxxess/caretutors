// lib/features/notes/data/notes_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../notes/models/note_model.dart';

class NotesRepository {
  final FirebaseFirestore firestore;

  NotesRepository({required this.firestore});

  Stream<List<Note>> getNotes(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Note.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> addNote(String userId, Note note) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add(note.toMap());
  }
/*  final CollectionReference notesCollection = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote(String noteId) async {
    try {
      await notesCollection.doc(noteId).delete();
    } catch (e) {
      print('Error deleting note: $e');
    }
  } */
  // Add other CRUD operations as needed
}
