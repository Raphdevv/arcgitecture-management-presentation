import 'package:architecture_management_data/architecture_management_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetAllNoteUseCase getAllNotes;
  final CreateNoteUseCase createNote;
  final UpdateNoteUseCase updateNote;
  final DeleteNoteUseCase deleteNote;
  final MergeNoteUsecase mergeNotes;

  NotesBloc({
    required this.getAllNotes,
    required this.createNote,
    required this.updateNote,
    required this.deleteNote,
    required this.mergeNotes,
  }) : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<CreateNote>(_onCreateNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<ToggleNoteSelection>(_onToggleNoteSelection);
    on<ClearSelection>(_onClearSelection);
    on<MergeSelectedNotes>(_onMergeSelectedNotes);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    final result = await getAllNotes();
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (notes) => emit(NotesLoaded(notes: notes)),
    );
  }

  Future<void> _onCreateNote(CreateNote event, Emitter<NotesState> emit) async {
    final result = await createNote(
      CreateNoteParams(name: event.name, description: event.description),
    );
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) => add(LoadNotes()),
    );
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    final result = await updateNote(
      UpdateNoteParams(
        id: event.id,
        name: event.name,
        description: event.description,
      ),
    );
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) => add(LoadNotes()),
    );
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    final result = await deleteNote(event.id);
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) => add(LoadNotes()),
    );
  }

  void _onToggleNoteSelection(
    ToggleNoteSelection event,
    Emitter<NotesState> emit,
  ) {
    if (state is! NotesLoaded) return;
    final current = state as NotesLoaded;
    final selected = List<NoteManagementEntity>.from(current.selectedNotes);

    if (selected.contains(event.note)) {
      selected.remove(event.note);
    } else if (selected.length < 2) {
      selected.add(event.note);
    }

    emit(current.copyWith(selectedNotes: selected));
  }

  void _onClearSelection(ClearSelection event, Emitter<NotesState> emit) {
    if (state is! NotesLoaded) return;
    final current = state as NotesLoaded;
    emit(current.copyWith(selectedNotes: []));
  }

  Future<void> _onMergeSelectedNotes(
    MergeSelectedNotes event,
    Emitter<NotesState> emit,
  ) async {
    if (state is! NotesLoaded) return;
    final current = state as NotesLoaded;
    if (current.selectedNotes.length != 2) return;

    final params = MergeNoteParams(
      content: current.selectedNotes
          .map(
            (n) => UpdateNoteParams(
              id: n.id,
              name: n.name,
              description: n.description,
            ),
          )
          .toList(),
    );

    final result = await mergeNotes(params: params);
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) => add(LoadNotes()),
    );
  }
}
