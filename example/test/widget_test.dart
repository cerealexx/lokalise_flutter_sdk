import 'package:example/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';
import 'package:lokalise_flutter_sdk/lokalise_flutter_sdk.dart';

void main() {
  Widget getApp(Locale locale) {
    return MaterialApp(
      title: 'Testing app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: Lt.localizationsDelegates,
      supportedLocales: Lt.supportedLocales,
      locale: locale,
      home: const MyHomePage(),
    );
  }

  testWidgets('English app should show Hello World!', (tester) async {
    await Lokalise.initMock();
    const locale = Locale('en');

    await tester.pumpWidget(getApp(locale));
    await tester.pumpAndSettle();

    expect(find.text('Hello World!'), findsOneWidget);
  });

  testWidgets('Spanish app should show ¡Hola Mundo!', (tester) async {
    await Lokalise.initMock();
    const locale = Locale('es');

    await tester.pumpWidget(getApp(locale));
    await tester.pumpAndSettle();

    expect(find.text('¡Hola Mundo!'), findsOneWidget);
  });

  testWidgets('Using cached data', (tester) async {
    const locale = Locale('en');
    const newTranslation = 'working from cache';
    await Lokalise.initMock(
      cachedBundleTranslations: {
        locale: {'helloWorld': newTranslation}
      },
    );

    await tester.pumpWidget(getApp(locale));
    await tester.pumpAndSettle();

    expect(find.text(newTranslation), findsOneWidget);
  });

  testWidgets('Using remote bundle translation', (tester) async {
    const locale = Locale('en');
    const newTranslation = 'working from remote bundle';
    await Lokalise.initMock(
      cachedBundleTranslations: {
        locale: {'helloWorld': 'this is not shown'}
      },
      remoteBundleTranslations: {
        locale: {'helloWorld': newTranslation}
      },
    );

    await tester.pumpWidget(getApp(locale));
    await tester.pumpAndSettle();

    expect(find.text(newTranslation), findsOneWidget);
  });
}
