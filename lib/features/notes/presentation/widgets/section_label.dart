import 'package:flutter/cupertino.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: CupertinoColors.systemGrey,
        letterSpacing: 0.5,
      ),
    );
  }
}
