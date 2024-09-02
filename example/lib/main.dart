import 'package:flutter/material.dart';
import 'package:lokalise_flutter_sdk/lokalise_flutter_sdk.dart'; // Imports the SDK
import 'l10n/generated/l10n.dart'; // Imports the generated Lt class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Configures the SDK
  await Lokalise.init(
    projectId: 'Project ID',
    sdkToken: 'Lokalise SDK Token',
    // Add this only if you want to use prereleases. Use the Bundle freeze functionality in production
    preRelease: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lokalise SDK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      localizationsDelegates: Lt.localizationsDelegates,
      supportedLocales: Lt.supportedLocales,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateTranslations();
  }

  void _updateTranslations() {
    setState(() => _isLoading = true);
    // Ensures the application has the latest translations
    Lokalise.instance.update().then(
          (_) => setState(() => _isLoading = false),
          onError: (error) => setState(() => _isLoading = false),
        );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _updateTranslations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Lt.of(context).title), // Gets the translation
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Center(
                child: Text(Lt.of(context).helloWorld), // Gets the translation
              ),
      ),
    );
  }
}
