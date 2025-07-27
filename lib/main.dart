import 'package:flutter/material.dart';
import 'widgets/spin_wheel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

  final List<String> items = [
    'Prize 1',
    'Prize 2',
    'Prize 3',
    'Prize 4',
    'Prize 5',
    'Prize 6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinWheel(
              items: items,
              selectedIndexNotifier: selectedIndexNotifier,
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<int>(
              valueListenable: selectedIndexNotifier,
              builder: (context, value, child) {
                return Text(
                  'Selected: ${items[value]}',
                  style: Theme.of(context).textTheme.headlineSmall,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}