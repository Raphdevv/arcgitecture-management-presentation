import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';

class MergeBar extends StatelessWidget {
  const MergeBar({super.key, required this.state});

  final NotesLoaded state;

  @override
  Widget build(BuildContext context) {
    final canMerge = state.selectedNotes.length == 2;

    return Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          top: BorderSide(color: CupertinoColors.separator, width: 0.5),
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              canMerge
                  ? 'Ready to merge 2 notes'
                  : 'Select ${2 - state.selectedNotes.length} more note${state.selectedNotes.length == 1 ? '' : 's'}',
              style: TextStyle(
                fontSize: 14,
                color: canMerge
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.systemGrey,
              ),
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: canMerge
                ? CupertinoColors.systemBlue
                : CupertinoColors.systemGrey4,
            borderRadius: BorderRadius.circular(10),
            onPressed: canMerge
                ? () => context.read<NotesBloc>().add(MergeSelectedNotes())
                : null,
            child: Text(
              'Merge',
              style: TextStyle(
                color: canMerge
                    ? CupertinoColors.white
                    : CupertinoColors.systemGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
