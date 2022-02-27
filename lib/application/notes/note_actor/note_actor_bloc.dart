import 'package:bloc/bloc.dart';
import 'package:flutter_ddd/domain/notes/i_note_repository.dart';
import 'package:flutter_ddd/domain/notes/note.dart';
import 'package:flutter_ddd/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'note_actor_event.dart';
part 'note_actor_state.dart';
part 'note_actor_bloc.freezed.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;
  NoteActorBloc(this._noteRepository) : super(const _Initial()) {
    on<NoteActorEvent>((event, emit) async {
      if (event is _Deleted) {
        emit(const NoteActorState.actionInProgress());
        final result = await _noteRepository.delete(event.note);
        result.fold(
          (f) => emit(NoteActorState.deleteFailure(f)),
          (_) => emit(const NoteActorState.deleteSuccess()),
        );
      }
    });
  }
}
