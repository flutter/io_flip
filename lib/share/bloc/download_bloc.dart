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
    on<DownloadRequested>(_onDownloadRequested);
  }

  final ShareResource _shareResource;
  late final XFile Function(Uint8List, {String? mimeType, String? name})
      _parseBytes;

  Future<void> _onDownloadRequested(
    DownloadRequested event,
    Emitter<DownloadState> emit,
  ) async {
    emit(state.copyWith(status: DownloadStatus.loading));
    try {
      final bytes = await _shareResource.getShareImage(event.card.id);
      final file = _parseBytes(
        bytes,
        mimeType: 'image/png',
        name: event.card.name,
      );
      await file.saveTo('${event.card.name}.png');

      emit(state.copyWith(status: DownloadStatus.completed));
    } catch (e) {
      emit(state.copyWith(status: DownloadStatus.failure));
    }
  }
}
