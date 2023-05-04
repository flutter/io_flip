import 'mocha';
import * as functionsTest from 'firebase-functions-test';
import * as sinon from 'sinon';
import * as admin from 'firebase-admin';
import {expect} from 'chai';

describe('deleteUserData', () => {
  let adminInitStub: sinon.SinonStub;
  let firestoreStub: sinon.SinonStub;
  let collectionStub: sinon.SinonStub;
  let storageStub: sinon.SinonStub;
  let bucketStub: sinon.SinonStub;
  let whereStub: sinon.SinonStub;
  let docStub: sinon.SinonStub;
  let deleteStub: sinon.SinonStub;
  let oldFirestore: typeof admin.firestore;
  let oldStorage: typeof admin.storage;
  const tester = functionsTest();
  const uid = 'UID-1234';

  before(async () => {
    oldFirestore = admin.firestore;
    oldStorage = admin.storage;

    adminInitStub = sinon.stub(admin, 'initializeApp');
    firestoreStub = sinon.stub();
    collectionStub = sinon.stub();
    storageStub = sinon.stub();
    bucketStub = sinon.stub();
    whereStub = sinon.stub();
    docStub = sinon.stub();
    deleteStub = sinon.stub();

    Object.defineProperty(admin, 'firestore', {value: firestoreStub, writable: true});
    Object.defineProperty(admin, 'storage', {value: storageStub, writable: true});

    firestoreStub.returns({collection: collectionStub});
    storageStub.returns({bucket: bucketStub});
  });

  after(() => {
    adminInitStub.restore();
    tester.cleanup();
    Object.defineProperty(admin, 'firestore', {value: oldFirestore});
    Object.defineProperty(admin, 'storage', {value: oldStorage});
  });

  function stubQuerySnapshot(ids: string[]): sinon.SinonStub {
    const docs = ids.map((id) => ({id: id, ref: {delete: deleteStub}}));
    const stub = sinon.stub();
    stub.returns(Promise.resolve({docs: docs}));
    return stub;
  }

  it(`should delete cards, decks, matches, match states, scorecards, 
    leaderboard, and connection states`,
  async () => {
    docStub.returns({delete: deleteStub});
    collectionStub.withArgs('cards').returns({doc: docStub});
    collectionStub.withArgs('decks').returns({where: whereStub});
    collectionStub.withArgs('matches').returns({where: whereStub});
    collectionStub.withArgs('match_states').returns({where: whereStub});
    collectionStub.withArgs('connection_states').returns({doc: docStub});
    collectionStub.withArgs('score_cards').returns({doc: docStub});
    collectionStub.withArgs('leaderboard').returns({doc: docStub});

    const cardIds = ['card1', 'card2', 'card3'];
    const decksStub = sinon.stub();
    decksStub.returns(
      Promise.resolve({
        docs: [
          {
            id: 'deck1',
            ref: {delete: deleteStub},
            data: () => ({cards: cardIds}),
          },
        ],
      }
      ));
    const cpuDecksStub = sinon.stub();
    cpuDecksStub.returns(
      Promise.resolve({
        docs: [
          {
            id: 'cpuDeck1',
            ref: {delete: deleteStub},
            data: () => ({cards: cardIds}),
          },
        ],
      }));
    whereStub.withArgs('userId', '==', uid).returns({get: decksStub});
    whereStub.withArgs('userId', '==', `CPU_${uid}`).returns({get: cpuDecksStub});

    const hostMatchStub = stubQuerySnapshot(['match1', 'match2']);
    const guestMatchStub = stubQuerySnapshot(['match3', 'match4']);
    whereStub.withArgs('host', 'in', ['deck1', 'cpuDeck1']).returns({get: hostMatchStub});
    whereStub.withArgs('guest', 'in', ['deck1', 'cpuDeck1']).returns({get: guestMatchStub});

    const matchStateStub = stubQuerySnapshot([
      'matchState1', 'matchState2', 'matchState3', 'matchState4']);
    whereStub.withArgs('matchId', 'in', ['match1', 'match2', 'match3', 'match4'])
      .returns({get: matchStateStub});

    const fileStub = sinon.stub();
    const deleteFileStub = sinon.stub().returns(Promise.resolve());
    fileStub.returns({delete: deleteFileStub});
    bucketStub.returns({file: fileStub});

    const userRecord = sinon.stub().returns({uid});
    const wrapped = tester.wrap((await import('../src/deleteUserData')).deleteUserData);
    await wrapped(userRecord());

    expect(collectionStub.calledWith('cards')).to.be.true;
    expect(collectionStub.calledWith('decks')).to.be.true;
    expect(collectionStub.calledWith('matches')).to.be.true;
    expect(collectionStub.calledWith('match_states')).to.be.true;
    expect(collectionStub.calledWith('connection_states')).to.be.true;
    expect(collectionStub.calledWith('score_cards')).to.be.true;
    expect(collectionStub.calledWith('leaderboard')).to.be.true;
    expect(whereStub.calledWith('userId', '==', uid)).to.be.true;
    expect(whereStub.calledWith('userId', '==', `CPU_${uid}`)).to.be.true;
    expect(whereStub.calledWith('host', 'in', ['deck1', 'cpuDeck1'])).to.be.true;
    expect(whereStub.calledWith('guest', 'in', ['deck1', 'cpuDeck1'])).to.be.true;
    expect(
      whereStub.calledWith('matchId', 'in', ['match1', 'match2', 'match3', 'match4'])).to.be.true;
    expect(docStub.calledWith('card1')).to.be.true;
    expect(docStub.calledWith('card2')).to.be.true;
    expect(docStub.calledWith('card3')).to.be.true;
    expect(docStub.withArgs(uid).calledThrice).to.be.true;
    for (let i = 0; i < cardIds.length; i++) {
      expect(fileStub.calledWith(`share/${cardIds[i]}.png`)).to.be.true;
    }
    expect(fileStub.calledWith('share/deck1.png')).to.be.true;
    expect(fileStub.calledWith('share/cpuDeck1.png')).to.be.true;
    expect(deleteStub.callCount).to.equal(17);
    expect(deleteFileStub.callCount).to.equal(cardIds.length + 2);
  }
  );
});
