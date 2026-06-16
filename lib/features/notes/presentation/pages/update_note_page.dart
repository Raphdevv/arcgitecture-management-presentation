import 'package:architecture_management_data/architecture_management_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../widgets/section_label.dart';

class UpdateNotePage extends StatefulWidget {
  const UpdateNotePage({super.key, required this.note});

  final NoteManagementEntity note;

  @override
  State<UpdateNotePage> createState() => _UpdateNotePageState();
}

class _UpdateNotePageState extends State<UpdateNotePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.note.name);
    _descController = TextEditingController(text: widget.note.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    if (name.isEmpty) return;

    context.read<NotesBloc>().add(
      UpdateNote(id: widget.note.id, name: name, description: desc),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Edit Note'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _submit,
          child: const Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            const SectionLabel(label: 'NAME'),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: _nameController,
              placeholder: 'Note name',
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: CupertinoColors.tertiarySystemBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            const SectionLabel(label: 'DESCRIPTION'),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: _descController,
              placeholder: 'Add a description...',
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: CupertinoColors.tertiarySystemBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              maxLines: 5,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 32),
            CupertinoButton.filled(
              borderRadius: BorderRadius.circular(12),
              onPressed: _submit,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
