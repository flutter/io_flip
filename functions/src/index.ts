import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp(functions.config().firebase);

export {deleteUserData} from './deleteUserData';
export {updateLeaderboard} from './updateLeaderboard';
