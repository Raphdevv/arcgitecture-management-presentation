import 'package:architecture_management_data/architecture_management_data.dart';
import 'package:get_it/get_it.dart';

import 'features/notes/presentation/bloc/notes_bloc.dart';

final GetIt sl = GetIt.asNewInstance();

Future<void> setupInjector() async {
  await setupArchitectureManagementInjector(sl: sl, forceLocal: true);

  sl.registerFactory(
    () => NotesBloc(
      getAllNotes: sl<GetAllNoteUseCase>(),
      createNote: sl<CreateNoteUseCase>(),
      updateNote: sl<UpdateNoteUseCase>(),
      deleteNote: sl<DeleteNoteUseCase>(),
      mergeNotes: sl<MergeNoteUsecase>(),
    ),
  );
}
