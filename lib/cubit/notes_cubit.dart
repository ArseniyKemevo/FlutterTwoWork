import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(const NotesState([]));

  void addNote(String text) {
    final trimmed = text.trim();
    if (trimmed.isNotEmpty) {
      emit(NotesState([...state.notes, trimmed]));
    }
  }

  void deleteNote(int index) {
    final updated = List<String>.from(state.notes)..removeAt(index);
    emit(NotesState(updated));
  }

  void editNote(int index, String newText) {
    final trimmed = newText.trim();
    if (trimmed.isNotEmpty) {
      final updated = List<String>.from(state.notes);
      updated[index] = trimmed;
      emit(NotesState(updated));
    }
  }
}