// filepath: /C:/src/TheNomNomCollective/the_nomnom_collective/integration_test/email_test.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_nomnom_collective/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBF5TwhHlPo5Otm5hZy3LcgoHDQaE8qjw8",
        appId: "1:956835114993:android:85581df282762a3c159e50",
        messagingSenderId: "956835114993",
        projectId: "the-nomnom-collective",
      ),
    );
  });

  testWidgets('Testing the E-Mail login system', (tester) async {
    await tester.pumpWidget(MyApp());

    await tester.enterText(find.byKey(Key('Email')), 'dadad');
    await tester.enterText(find.byKey(Key('Password')), '123456789');

    await tester.tap(find.byKey(Key('LoginButton')));

    expect(find.byType(SnackBar), findsOneWidget);
  });
}