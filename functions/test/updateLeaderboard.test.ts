import 'mocha';
import * as functionsTest from 'firebase-functions-test';
import * as sinon from 'sinon';
import * as admin from 'firebase-admin';
import {expect} from 'chai';
import {FeaturesList} from 'firebase-functions-test/lib/features';

describe('updateLeaderboard', () => {
  let adminInitStub: sinon.SinonStub;
  let firestoreStub: sinon.SinonStub;
  let collectionStub: sinon.SinonStub;
  let docStub: sinon.SinonStub;
  let getStub: sinon.SinonStub;
  let setStub: sinon.SinonStub;
  let updateStub: sinon.SinonStub;
  let oldFirestore: typeof admin.firestore;
  let tester: FeaturesList;
  const docId = 'card-1234';

  before(async () => {
    tester = functionsTest();
    oldFirestore = admin.firestore;

    adminInitStub = sinon.stub(admin, 'initializeApp');
    firestoreStub = sinon.stub();
    collectionStub = sinon.stub();
    docStub = sinon.stub();
    getStub = sinon.stub();
    setStub = sinon.stub();
    updateStub = sinon.stub();

    Object.defineProperty(admin, 'firestore', {value: firestoreStub, writable: true});

    firestoreStub.returns({collection: collectionStub});
    collectionStub.withArgs('leaderboard').returns({doc: docStub});
    docStub.returns({get: getStub, set: setStub, update: updateStub});
  });

  afterEach(() => {
    adminInitStub.restore();
    firestoreStub.resetHistory();
    collectionStub.resetHistory();
    docStub.resetHistory();
    getStub.resetHistory();
    setStub.resetHistory();
    updateStub.resetHistory();
  });

  after(() => {
    tester.cleanup();
    Object.defineProperty(admin, 'firestore', {value: oldFirestore});
  });


  it('should set a new leaderboard document if it does not exist', async () => {
    const change = sinon.stub().returns({
      before: {
        id: docId,
        data: () => ({
          longestStreak: 42,
          initials: 'ABC',
        }),
      },
      after: {
        id: docId,
        data: () => ({
          longestStreak: 42,
          initials: 'ABC',
        }),
      },
    });

    getStub.returns(Promise.resolve({exists: false}));

    const wrapped = tester.wrap(
      (await import('../src/updateLeaderboard')).updateLeaderboard
    );
    await wrapped(change());

    expect(docStub.calledWith(docId)).to.be.true;
    expect(getStub.calledOnce).to.be.true;
    expect(setStub.calledOnce).to.be.true;
    expect(updateStub.notCalled).to.be.true;
  });

  it(
    'should update an existing leaderboard document if new streak is longer than previous',
    async () => {
      const change = sinon.stub().returns({
        before: {
          id: docId,
          data: () => ({
            longestStreak: 50,
            initials: 'ABC',
          }),
        },
        after: {
          id: docId,
          data: () => ({
            longestStreak: 50,
            initials: 'ABC',
          }),
        },
      });

      getStub.returns(Promise.resolve({
        exists: true, get: (field) => {
          if (field === 'longestStreak') {
            return 40;
          }
          return undefined;
        },
      }));

      const wrapped = tester.wrap(
        (await import('../src/updateLeaderboard')).updateLeaderboard
      );
      await wrapped(change());

      expect(docStub.calledWith(docId)).to.be.true;
      expect(getStub.calledOnce).to.be.true;
      expect(setStub.notCalled).to.be.true;
      expect(updateStub.calledOnce).to.be.true;
    });
});
