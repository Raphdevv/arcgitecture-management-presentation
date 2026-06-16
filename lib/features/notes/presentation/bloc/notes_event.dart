import 'package:architecture_management_data/architecture_management_data.dart';

abstract class NotesEvent {}

class LoadNotes extends NotesEvent {}

class CreateNote extends NotesEvent {
  final String name;
  final String description;
  CreateNote({required this.name, required this.description});
}

class DeleteNote extends NotesEvent {
  final String id;
  DeleteNote({required this.id});
}

class UpdateNote extends NotesEvent {
  final String id;
  final String name;
  final String description;
  UpdateNote({required this.id, required this.name, required this.description});
}

class ToggleNoteSelection extends NotesEvent {
  final NoteManagementEntity note;
  ToggleNoteSelection({required this.note});
}

class ClearSelection extends NotesEvent {}

class MergeSelectedNotes extends NotesEvent {}
