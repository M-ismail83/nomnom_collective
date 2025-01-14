import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class CustomMockFirebaseAuth extends MockFirebaseAuth {
  final String correctPassword;
  final String correctEmail;

  CustomMockFirebaseAuth({required MockUser mockUser, required this.correctPassword, required this.correctEmail}) : super(mockUser: mockUser);

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (password != correctPassword) {
      throw FirebaseAuthException(
        code: 'wrong-password',
        message: 'The password is invalid or the user does not have a password.',
      );
    } else if (email != correctEmail) {
      throw FirebaseAuthException(
        code: 'wrong-email',
        message: 'The email is invalid or the user does not have an email.');
    }
    return super.signInWithEmailAndPassword(email: email, password: password);
  }
}

void main() {
  // Mock a user
  late MockUser tUser;

  group('Testing Sign In with different email and passwords', () {

    //No problem here, sir
    test('Guaranteed Sign In Test No:1', () async {
      tUser = MockUser(
        email: 'mahmutcftbkr86@hotmail.com',
        displayName: 'Mahmut',
      );

      // Mocking the Firebase Auth. We need this to use firebase in tests
      final auth = CustomMockFirebaseAuth(mockUser: tUser, correctPassword: 'mhmcıftbk24', correctEmail: 'mahmutcftbkr86@hotmail.com');

      // Mock signing in
      final result = await auth.signInWithEmailAndPassword(
        email: tUser.email as String,
        password: 'mhmcıftbk24',
      );
      final user = result.user;

      expect(user, tUser);
      expect(auth.authStateChanges(), emitsInOrder([null, isA<User>()]));
      expect(auth.userChanges(), emitsInOrder([null, isA<User>()]));
    });

    //No problem here as well
    test('Guaranteed Sign In Test No:2', () async {
      tUser = MockUser(
        email: 'burcuckltas45@hotmail.com',
        displayName: 'Burcu',
      );

      // Mocking the Firebase Auth. We need this to use firebase in tests
      final auth = CustomMockFirebaseAuth(mockUser: tUser, correctPassword: 'burcakıl772', correctEmail: 'burcuckltas45@hotmail.com');

      // Mock signing in
      final result = await auth.signInWithEmailAndPassword(
        email: tUser.email as String,
        password: 'burcakıl772',
      );
      final user = result.user;

      expect(user, tUser);
      expect(auth.authStateChanges(), emitsInOrder([null, isA<User>()]));
      expect(auth.userChanges(), emitsInOrder([null, isA<User>()]));
    });

    //This tests the sign in method with wrong password
    test('Wrong Sign In Test: Wrong Password', () async {
      tUser = MockUser(
        email: 'cngzturker26@hotmail.com',
        displayName: 'Cengiz',
      );

      // Mocking the Firebase Auth. We need this to use firebase in tests
      final auth = CustomMockFirebaseAuth(mockUser: tUser, correctPassword: 'centurk333', correctEmail: 'cngzturker26@hotmail.com');

      // Attempt to sign in with incorrect password
      expect(
        () async => await auth.signInWithEmailAndPassword(
          email: tUser.email as String,
          password: 'centur333',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );

      // Ensure no user is signed in
      expect(auth.currentUser, isNull);
      expect(auth.authStateChanges(), emitsInOrder([null]));
      expect(auth.userChanges(), emitsInOrder([null]));
    });

    //This tests the sign in method with wrong email
    test('Wrong Sign In Test: Wrong Email', () async {
      tUser = MockUser(
        email: 'elfgulerhotmail.com',
        displayName: 'Elif',
      );

      // Mocking the Firebase Auth. We need this to use firebase in tests
      final auth = CustomMockFirebaseAuth(mockUser: tUser, correctPassword: 'elifelfi84', correctEmail: 'elfguler87@hotmail.com');

      // Attempt to sign in with incorrect password
      expect(
        () async => await auth.signInWithEmailAndPassword(
          email: tUser.email as String,
          password: 'elifelfi84',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );

      // Ensure no user is signed in
      expect(auth.currentUser, isNull);
      expect(auth.authStateChanges(), emitsInOrder([null]));
      expect(auth.userChanges(), emitsInOrder([null]));
    });

    //This is a test that won't pass on purpuse
    test('My Favourite: Guatanteed Wrong Sign İn', () async {
      tUser = MockUser(
        email: '',
        displayName: 'Elif',
      );

      // Mocking the Firebase Auth. We need this to use firebase in tests
      final auth = CustomMockFirebaseAuth(mockUser: tUser, correctPassword: 'elifelfi84', correctEmail: 'elfguler87@hotmail.com');

      // Attempt to sign in with incorrect password
      expect(
        () async => await auth.signInWithEmailAndPassword(
          email: tUser.email as String,
          password: '',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );

      // Ensure that user is signed in
      expect(auth.currentUser, tUser);
      expect(auth.authStateChanges(), emitsInOrder([null, isA<User>()]));
      expect(auth.userChanges(), emitsInOrder([null, isA<User>()]));
    });
  });
}