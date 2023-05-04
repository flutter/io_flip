import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

const firestore = admin.firestore();

export const updateLeaderboard = functions.firestore.document('score_cards/{card}').onUpdate(
  async (change): Promise<void> => {
    const card = change.after.data();
    const longestStreak: number | undefined = card.longestStreak;
    const initials: string | undefined = card.initials;
    const docId: string = change.after.id;

    if (initials && longestStreak) {
      const docRef = firestore.collection('leaderboard').doc(docId);
      const snapshot = await docRef.get();

      if (snapshot.exists) {
        const currentStreak = snapshot.get('longestStreak');
        if (longestStreak > currentStreak) {
          await docRef.update({
            longestStreak: longestStreak,
            initials: initials,
          });
        }
      } else {
        await docRef.set({
          longestStreak: longestStreak,
          initials: initials,
        });
      }
    }
  });
