// lib/providers/notes_provider.dart
import 'package:caretutors/features/notes/data/notes_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/notes/models/note_model.dart';
import '../providers/auth_provider.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository(firestore: ref.watch(firestoreProvider));
});

final notesStreamProvider = StreamProvider<List<Note>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(notesRepositoryProvider).getNotes(user.uid);
});
