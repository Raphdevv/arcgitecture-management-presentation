import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/notes/presentation/bloc/notes_bloc.dart';
import 'features/notes/presentation/bloc/notes_event.dart';
import 'features/notes/presentation/pages/notes_page.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjector();
  await sl.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Notes',
      theme: const CupertinoThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => sl<NotesBloc>()..add(LoadNotes()),
        child: const NotesPage(),
      ),
    );
  }
}
