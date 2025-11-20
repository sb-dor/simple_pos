import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/synchronization/data/synchronization_repository.dart';

part 'synchronization_bloc.freezed.dart';

@freezed
sealed class SynchronizationEvent with _$SynchronizationEvent {
  const factory SynchronizationEvent.sync({
    @Default(false) final bool refresh,
    final void Function()? onSyncDone,
  }) = _Synchronization$SyncEvent;

  const factory SynchronizationEvent.changeStateToInitial() =
      _Synchronization$ChangeStateToInitialEvent;
}

@freezed
sealed class SynchronizationState with _$SynchronizationState {
  const factory SynchronizationState.initial() = Synchronization$InitialState;

  const factory SynchronizationState.inProgress() = Synchronization$InProgressState;

  const factory SynchronizationState.error({final String? message}) = Synchronization$ErrorState;

  const factory SynchronizationState.completed() = Synchronization$CompletedState;
}

class SynchronizationBloc extends Bloc<SynchronizationEvent, SynchronizationState> {
  SynchronizationBloc({required final ISynchronizationRepository iSynchronizationRepository})
    : _iSynchronizationRepository = iSynchronizationRepository,
      super(const SynchronizationState.initial()) {
    //
    on<SynchronizationEvent>(
      (event, emit) => switch (event) {
        final _Synchronization$SyncEvent event => _synchronizationEvent(event, emit),
        final _Synchronization$ChangeStateToInitialEvent event =>
          _synchronization$ChangeStateToInitialEvent(event, emit),
      },
    );
  }

  final ISynchronizationRepository _iSynchronizationRepository;

  Future<void> _synchronizationEvent(
    _Synchronization$SyncEvent event,
    Emitter<SynchronizationState> emit,
  ) async {
    if (state is Synchronization$CompletedState && !event.refresh) return;
    try {
      emit(const SynchronizationState.inProgress());

      final sync = await _iSynchronizationRepository.sync();

      if (!sync) {
        emit(
          const SynchronizationState.error(message: 'Something went wrong with table synchronization'),
        );
        return;
      }

      event.onSyncDone?.call();
      emit(const SynchronizationState.completed());
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(const SynchronizationState.error());
    }
  }

  Future<void> _synchronization$ChangeStateToInitialEvent(
    _Synchronization$ChangeStateToInitialEvent event,
    Emitter<SynchronizationState> emit,
  ) async => emit(const SynchronizationState.initial());
}
