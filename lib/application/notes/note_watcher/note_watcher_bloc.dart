import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_ddd/domain/notes/i_note_repository.dart';
import 'package:flutter_ddd/domain/notes/note.dart';
import 'package:flutter_ddd/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

part 'note_watcher_event.dart';
part 'note_watcher_state.dart';
part 'note_watcher_bloc.freezed.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;

  StreamSubscription<Either<NoteFailure, KtList<Note>>>?
      _noteStreamSubscription;

  NoteWatcherBloc(this._noteRepository) : super(const _Initial()) {
    on<NoteWatcherEvent>((event, emit) async {
      if (event is _WatchAllStarted) {
        _noteStreamSubscription?.cancel();
        emit(const NoteWatcherState.loadInProgress());
        _noteStreamSubscription =
            _noteRepository.watchAll().listen((notes) async {
          add(_WatchAllReceived(notes));
        });
      } else if (event is _WatchUncompletedStarted) {
        _noteStreamSubscription?.cancel();
        emit(const NoteWatcherState.loadInProgress());
        _noteStreamSubscription =
            _noteRepository.watchUncompleted().listen((notes) async {
          add(_WatchAllReceived(notes));
        });
      } else if (event is _WatchAllReceived) {
        event.failureOrNotes.fold(
            (f) => emit(NoteWatcherState.loadFailure(f)),
            (r) => emit(
                  NoteWatcherState.loadSuccess(r),
                ));
      }
    });
  }

  @override
  Future<void> close() async {
    await _noteStreamSubscription?.cancel();
    return super.close();
  }
}
