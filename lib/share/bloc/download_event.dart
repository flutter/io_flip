part of 'download_bloc.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();
}

class DownloadCardsRequested extends DownloadEvent {
  const DownloadCardsRequested({required this.cards});

  final List<Card> cards;

  @override
  List<Object> get props => [cards];
}

class DownloadDeckRequested extends DownloadEvent {
  const DownloadDeckRequested({required this.deck});

  final Deck deck;

  @override
  List<Object> get props => [deck];
}
