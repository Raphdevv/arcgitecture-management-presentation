import 'package:architecture_management_data/architecture_management_data.dart';

abstract class NotesState {}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<NoteManagementEntity> notes;
  final List<NoteManagementEntity> selectedNotes;

  NotesLoaded({required this.notes, this.selectedNotes = const []});

  bool get isSelectionMode => selectedNotes.isNotEmpty;

  bool isSelected(NoteManagementEntity note) => selectedNotes.contains(note);

  NotesLoaded copyWith({
    List<NoteManagementEntity>? notes,
    List<NoteManagementEntity>? selectedNotes,
  }) {
    return NotesLoaded(
      notes: notes ?? this.notes,
      selectedNotes: selectedNotes ?? this.selectedNotes,
    );
  }
}

class NotesError extends NotesState {
  final String message;
  NotesError({required this.message});
}
