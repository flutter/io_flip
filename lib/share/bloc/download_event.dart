part of 'download_bloc.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();
}

class DownloadRequested extends DownloadEvent {
  const DownloadRequested({required this.card});

  final Card card;

  @override
  List<Object> get props => [card];
}
