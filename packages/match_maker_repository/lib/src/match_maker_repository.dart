import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:uuid/uuid.dart';

const _emptyKey = 'EMPTY';

const _inviteKey = 'INVITE';

/// Represents an error that occurs when a matchmaking process times out.
class MatchMakingTimeout extends Error {}

/// {@template match_maker_repository}
/// Repository for match making.
/// {@endtemplate}
class MatchMakerRepository {
  /// {@macro match_maker_repository}
  MatchMakerRepository({
    required this.db,
    ValueGetter<String>? inviteCode,
    this.retryDelay = _defaultRetryDelay,
  }) : _inviteCode = inviteCode ?? defaultInviteCodeGenerator {
    collection = db.collection('matches');
    matchStatesCollection = db.collection('match_states');
    scoreCardCollection = db.collection('score_cards');
  }

  static const _defaultRetryDelay = 2;
  static const _maxRetries = 3;

  final ValueGetter<String> _inviteCode;

  /// The delay between retries when finding a match.
  final int retryDelay;

  /// The [FirebaseFirestore] instance.
  final FirebaseFirestore db;

  /// The [CollectionReference] for the matches.
  late final CollectionReference<Map<String, dynamic>> collection;

  /// The [CollectionReference] for the match_states.
  late final CollectionReference<Map<String, dynamic>> matchStatesCollection;

  /// The [CollectionReference] for the score_cards.
  late final CollectionReference<Map<String, dynamic>> scoreCardCollection;

  /// Default generator of invite codes.
  static String defaultInviteCodeGenerator() => const Uuid().v4();

  /// Watches a match.
  Stream<DraftMatch> watchMatch(String id) {
    return collection.doc(id).snapshots().map((snapshot) {
      final id = snapshot.id;
      final data = snapshot.data()!;
      final host = data['host'] as String;
      final guest = data['guest'] as String;
      final hostConnected = data['hostConnected'] as bool?;
      final guestConnected = data['guestConnected'] as bool?;

      return DraftMatch(
        id: id,
        host: host,
        guest: guest == _emptyKey || guest == _inviteKey ? null : guest,
        hostConnected: hostConnected ?? false,
        guestConnected: guestConnected ?? false,
      );
    });
  }

  /// Watches a match state.
  Stream<MatchState> watchMatchState(String id) {
    return matchStatesCollection.doc(id).snapshots().map((snapshot) {
      final id = snapshot.id;
      final data = snapshot.data()!;
      final matchId = data['matchId'] as String;
      final hostCards = (data['hostPlayedCards'] as List).cast<String>();
      final guestCards = (data['guestPlayedCards'] as List).cast<String>();
      final result = MatchResult.valueOf(data['result'] as String?);

      return MatchState(
        id: id,
        matchId: matchId,
        hostPlayedCards: hostCards,
        guestPlayedCards: guestCards,
        result: result,
      );
    });
  }

  /// Watches a ScoreCard.
  Stream<ScoreCard> watchScoreCard(String id) {
    final ref = scoreCardCollection.doc(id);
    final docStream = ref.snapshots();
    return docStream.map((snapshot) {
      final id = snapshot.id;
      final data = {...snapshot.data()!, 'id': id};
      return ScoreCard.fromJson(data);
    });
  }

  DraftMatch _mapMatchQueryElement(
    QueryDocumentSnapshot<Map<String, dynamic>> element,
  ) {
    final id = element.id;
    final data = element.data();
    final host = data['host'] as String;
    final hostConnected = data['hostConnected'] as bool?;
    final guestConnected = data['guestConnected'] as bool?;
    final inviteCode = data['inviteCode'] as String?;

    return DraftMatch(
      id: id,
      host: host,
      hostConnected: hostConnected ?? false,
      guestConnected: guestConnected ?? false,
      inviteCode: inviteCode,
    );
  }

  /// Gets the user's ScoreCard.
  Future<ScoreCard> getScoreCard(String id) async {
    final snapshot = await scoreCardCollection.doc(id).get();
    if (!snapshot.exists || snapshot.data() == null) {
      return _createScoreCard(id);
    }
    final data = {...snapshot.data()!, 'id': id};
    return ScoreCard.fromJson(data);
  }

  /// Finds a match.
  Future<DraftMatch> findMatch(String id, {int retryNumber = 0}) async {
    /// Find a match that is not full and has
    /// been updated in the last 4 seconds.
    final matchesResult = await collection
        .where(
          'guest',
          isEqualTo: _emptyKey,
        )
        .where(
          'hostConnected',
          isEqualTo: true,
        )
        .limit(3)
        .get();

    if (matchesResult.docs.isEmpty) {
      log('No match available, creating a new one.');
      return _createMatch(id);
    } else {
      final matches = matchesResult.docs.map(_mapMatchQueryElement).toList();

      for (final match in matches) {
        try {
          await db.runTransaction<Transaction>((transaction) async {
            final ref = collection.doc(match.id);
            return transaction.update(ref, {'guest': id});
          });
          return match.copyWithGuest(guest: id);
        } catch (e) {
          log('Match "${match.id}" already matched, trying next...');
        }
      }

      if (retryNumber == _maxRetries) {
        throw MatchMakingTimeout();
      }

      log('No match available, trying again in 2 seconds...');
      return Future.delayed(
        Duration(seconds: retryDelay),
        () => findMatch(id, retryNumber: retryNumber + 1),
      );
    }
  }

  /// Creates a private match that can only be joined with an invitation code.
  Future<DraftMatch> createPrivateMatch(String id) => _createMatch(
        id,
        inviteOnly: true,
      );

  /// Searches for and join a private match. Returns null if none is found.
  Future<DraftMatch?> joinPrivateMatch({
    required String guestId,
    required String inviteCode,
  }) async {
    final matchesResult = await collection
        .where('guest', isEqualTo: _inviteKey)
        .where('inviteCode', isEqualTo: inviteCode)
        .limit(3)
        .get();

    final matches = matchesResult.docs.map(_mapMatchQueryElement).toList();

    if (matches.isNotEmpty) {
      final match = matches.first;

      await db.runTransaction<Transaction>((transaction) async {
        final ref = collection.doc(match.id);
        return transaction.update(ref, {
          'guest': guestId,
        });
      });
      return match.copyWithGuest(guest: guestId);
    }

    return null;
  }

  Future<DraftMatch> _createMatch(String id, {bool inviteOnly = false}) async {
    final inviteCode = inviteOnly ? _inviteCode() : null;
    final result = await collection.add({
      'host': id,
      'guest': inviteOnly ? _inviteKey : _emptyKey,
      if (inviteCode != null) 'inviteCode': inviteCode,
    });

    await matchStatesCollection.add({
      'matchId': result.id,
      'hostPlayedCards': const <String>[],
      'guestPlayedCards': const <String>[],
    });
    return DraftMatch(
      id: result.id,
      host: id,
      inviteCode: inviteCode,
    );
  }

  Future<ScoreCard> _createScoreCard(String id) async {
    await scoreCardCollection.doc(id).set({
      'wins': 0,
      'longestStreak': 0,
      'currentStreak': 0,
    });
    return ScoreCard(
      id: id,
    );
  }
}
