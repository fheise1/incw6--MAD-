import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    // Provide the model to all widgets within the app. We're using
    // ChangeNotifierProvider because that's a simple way to rebuild
    // widgets when a model changes. We could also just use
    // Provider, but then we would have to listen to Counter ourselves.
    //
    // Read Provider's docs to learn about all the available providers.
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own Counter's lifecycle, making sure to call `dispose`
      // when not needed anymore.
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.
class Counter with ChangeNotifier {
  int age = 0;
  int step = 1;
  String ageText = "You're a child!";

  void setStep(double newStep) {
    step = newStep.toInt();
    notifyListeners();
  }

  void increment() {
    age += step;
    ageRange();
    notifyListeners();
  }

  void decrement() {
    age -= step;
    if (age < 0) age = 0;
    ageRange();
    notifyListeners();
  }

  void ageRange() {
    if (age < 13) {
      ageText = "You're a child!";
    } else if (age < 20) {
      ageText = "Teenager Time!";
    } else if (age < 30) {
      ageText = "You're a young adult!";
    } else if (age < 50) { 
      ageText = "You're an adult now!";
    } else {
      ageText = "Golden Years!";
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In Classwork 6'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<Counter>(
              builder: (context, counter, child) => Text(
                'I am ${counter.age} years old',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Consumer<Counter>(
              builder: (context, counter, child) => Slider(
                value: counter.step.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                label: '${counter.step}',
                onChanged: (value) {
                  counter.setStep(value);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    var counter = context.read<Counter>();
                    counter.increment();
                  }, 
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white, 
                  ),
                  child: const Text('Increase Age'),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () {
                    var counter = context.read<Counter>();
                    counter.decrement();
                  }, 
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white, 
                  ),
                  child: const Text('Reduce Age'),
                ),
              ],
            ),
            Consumer<Counter>(
              builder: (context, counter, child) => Text(
                counter.ageText,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}