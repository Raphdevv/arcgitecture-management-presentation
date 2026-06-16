import 'package:architecture_management_data/architecture_management_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../pages/update_note_page.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({super.key, required this.note, required this.state});

  final NoteManagementEntity note;
  final NotesLoaded state;

  @override
  Widget build(BuildContext context) {
    final isSelected = state.isSelected(note);

    return GestureDetector(
      onTap: () =>
          context.read<NotesBloc>().add(ToggleNoteSelection(note: note)),
      onLongPress: () => _showActions(context),
      child: Container(
        color: isSelected
            ? CupertinoColors.systemBlue.withAlpha(25)
            : CupertinoColors.systemBackground,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (note.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      note.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (state.isSelectionMode || isSelected) ...[
              const SizedBox(width: 12),
              Icon(
                isSelected
                    ? CupertinoIcons.checkmark_circle_fill
                    : CupertinoIcons.circle,
                color: isSelected
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.systemGrey3,
                size: 22,
              ),
            ] else ...[
              const SizedBox(width: 8),
              const Icon(
                CupertinoIcons.chevron_right,
                color: CupertinoColors.systemGrey3,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showActions(BuildContext context) {
    final bloc = context.read<NotesBloc>();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              _openEditNote(context, bloc);
            },
            child: const Text('Edit'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              bloc.add(DeleteNote(id: note.id));
            },
            child: const Text('Delete'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _openEditNote(BuildContext context, NotesBloc bloc) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: UpdateNotePage(note: note),
        ),
      ),
    );
  }
}
