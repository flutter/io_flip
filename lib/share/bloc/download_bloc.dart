import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:game_domain/game_domain.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc({
    required ShareResource shareResource,
    XFile Function(Uint8List, {String? mimeType, String? name})? parseBytes,
  })  : _shareResource = shareResource,
        _parseBytes = parseBytes ?? XFile.fromData,
        super(const DownloadState()) {
    on<DownloadCardsRequested>(_onDownloadCardRequested);
    on<DownloadDeckRequested>(_onDownloadDeckRequested);
  }

  final ShareResource _shareResource;
  late final XFile Function(Uint8List, {String? mimeType, String? name})
      _parseBytes;

  Future<void> _onDownloadCardRequested(
    DownloadCardsRequested event,
    Emitter<DownloadState> emit,
  ) async {
    emit(state.copyWith(status: DownloadStatus.loading));
    try {
      for (final card in event.cards) {
        final bytes = await _shareResource.getShareCardImage(card.id);
        final file = _parseBytes(
          bytes,
          mimeType: 'image/png',
          name: card.name,
        );
        await file.saveTo('${card.name}.png');

        emit(state.copyWith(status: DownloadStatus.completed));
      }
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: DownloadStatus.failure));
    }
  }

  Future<void> _onDownloadDeckRequested(
    DownloadDeckRequested event,
    Emitter<DownloadState> emit,
  ) async {
    emit(state.copyWith(status: DownloadStatus.loading));
    try {
      final bytes = await _shareResource.getShareDeckImage(event.deck.id);
      final file = _parseBytes(
        bytes,
        mimeType: 'image/png',
        name: 'My Team',
      );
      await file.saveTo('My Team.png');

      emit(state.copyWith(status: DownloadStatus.completed));
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: DownloadStatus.failure));
    }
  }
}
