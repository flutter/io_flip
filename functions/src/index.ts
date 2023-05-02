import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

function chunk<T>(arr: T[], size: number): T[][] {
  const acc = <T[][]>[];

  for (let i = 0; i < arr.length; i += size) {
    acc.push(arr.slice(i, i + size));
  }

  return acc;
}

async function chunkedQuery(
  collection: admin.firestore.CollectionReference,
  field: string, filter: admin.firestore.WhereFilterOp,
  values: string[],
): Promise<admin.firestore.QueryDocumentSnapshot<admin.firestore.DocumentData>[]> {
  const results = await Promise.all(
    chunk(values, 10).map(
      (chunk) => collection.where(field, filter, chunk).get()
    )
  );

  return results.flatMap((result) => result.docs);
}

export const deleteUserData = functions.auth.user().onDelete(async (event) => {
  const app = admin.initializeApp(functions.config().firebase);
  const firestore = admin.firestore(app);
  const storage = admin.storage(app);

  functions.logger.log('Deleting user data');
  const uid = event.uid;

  const userDecks = await firestore.collection('decks').where('userId', '==', uid).get();
  const cpuDecks = await firestore.collection('decks').where('userId', '==', `CPU_${uid}`).get();
  const decks = userDecks.docs.concat(cpuDecks.docs);
  const deckIds = decks.map((doc) => doc.id);

  const cardIds: string[] = [...new Set(decks.flatMap((doc) => doc.data()['cards']))];
  const cardDocs = cardIds.flatMap((id) => firestore.collection('cards').doc(id));

  const hostMatches = await chunkedQuery(firestore.collection('matches'), 'host', 'in', deckIds);
  const guestMatches = await chunkedQuery(firestore.collection('matches'), 'guest', 'in', deckIds);

  const matchIds = hostMatches.map((doc) => doc.id).concat(guestMatches.map((doc) => doc.id));
  const matchStates = await chunkedQuery(
    firestore.collection('match_states'),
    'matchId',
    'in',
    matchIds
  );

  const connectionDoc = firestore.collection('connection_states').doc(uid);
  const scoreCardDoc = firestore.collection('score_cards').doc(uid);
  const cpuScoreCardDoc = firestore.collection('score_cards').doc(`CPU_${uid}`);

  const bucket = storage.bucket();

  await Promise.all(
    cardIds.map((id) => bucket.file(`share/${id}.png`).delete({ignoreNotFound: true}))
  );
  await Promise.all(cardDocs.map((doc) => doc.delete()));
  await Promise.all(decks.map((doc) => doc.ref.delete()));
  await Promise.all(hostMatches.map((doc) => doc.ref.delete()));
  await Promise.all(guestMatches.map((doc) => doc.ref.delete()));
  await Promise.all(matchStates.map((doc) => doc.ref.delete()));
  await connectionDoc.delete();
  await scoreCardDoc.delete();
  await cpuScoreCardDoc.delete();

  functions.logger.log('Done with delete');

  return null;
});
