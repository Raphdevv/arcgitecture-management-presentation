import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../widgets/empty_notes_placeholder.dart';
import '../widgets/merge_bar.dart';
import '../widgets/note_tile.dart';
import 'create_note_page.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {
        if (state is NotesError) {
          showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: const Text('Error'),
              content: Text(state.message),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<NotesBloc>().add(LoadNotes());
                  },
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        final isSelectionMode = state is NotesLoaded && state.isSelectionMode;

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('Notes'),
            trailing: isSelectionMode
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () =>
                        context.read<NotesBloc>().add(ClearSelection()),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: CupertinoColors.destructiveRed),
                    ),
                  )
                : CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _openCreateNote(context),
                    child: const Icon(CupertinoIcons.add),
                  ),
          ),
          child: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, NotesState state) {
    if (state is NotesInitial || state is NotesLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }
    if (state is NotesLoaded) {
      if (state.notes.isEmpty) return const EmptyNotesPlaceholder();
      return _buildList(context, state);
    }
    return const SizedBox.shrink();
  }

  Widget _buildList(BuildContext context, NotesLoaded state) {
    return Stack(
      children: [
        SafeArea(
          bottom: false,
          child: ListView.separated(
            padding: EdgeInsets.only(
              top: 8,
              bottom: state.isSelectionMode ? 100 : 16,
            ),
            itemCount: state.notes.length,
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 0.5,
                child: ColoredBox(color: CupertinoColors.separator),
              ),
            ),
            itemBuilder: (context, index) {
              final note = state.notes[index];
              return NoteTile(note: note, state: state);
            },
          ),
        ),
        if (state.isSelectionMode)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MergeBar(state: state),
          ),
      ],
    );
  }

  void _openCreateNote(BuildContext context) {
    final bloc = context.read<NotesBloc>();
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) =>
            BlocProvider.value(value: bloc, child: const CreateNotePage()),
      ),
    );
  }
}
