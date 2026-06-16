import 'package:flutter/cupertino.dart';

class EmptyNotesPlaceholder extends StatelessWidget {
  const EmptyNotesPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.doc_text,
            size: 48,
            color: CupertinoColors.systemGrey3,
          ),
          SizedBox(height: 12),
          Text(
            'No notes yet',
            style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
