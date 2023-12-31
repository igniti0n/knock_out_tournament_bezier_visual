import 'package:flutter/material.dart';
import 'package:practice/connections_painter.dart';
import 'package:practice/element_pair.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ConnectWidgets(),
    );
  }
}

class ConnectWidgets extends StatelessWidget {
  const ConnectWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WidgetScreenData> elements = [
      const WidgetScreenData(
        Offset(40, 40),
        Size(100, 100),
        'Game 1',
      ),
      const WidgetScreenData(
        Offset(400, 140),
        Size(100, 100),
        'Game 2',
      ),
      const WidgetScreenData(
        Offset(40, 240),
        Size(100, 100),
        'Game 3',
      ),
      const WidgetScreenData(
        Offset(40, 440),
        Size(100, 100),
        'Game 4',
      ),
      const WidgetScreenData(
        Offset(40, 640),
        Size(100, 100),
        'Game 5',
      ),
      const WidgetScreenData(
        Offset(400, 540),
        Size(100, 100),
        'Game 6',
      ),
      const WidgetScreenData(
        Offset(700, 340),
        Size(100, 100),
        'Game 7',
      ),
    ];

    final List<ElementPair> pairs = [
      ElementPair(
        elements[0],
        elements[1],
      ),
      ElementPair(
        elements[2],
        elements[1],
      ),
      ElementPair(
        elements[3],
        elements[5],
      ),
      ElementPair(
        elements[4],
        elements[5],
      ),
      ElementPair(
        elements[1],
        elements[6],
      ),
      ElementPair(
        elements[5],
        elements[6],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: CustomPaint(
        painter: ElementsConnectionsPainter(
          pairs: pairs,
        ),
        child: _Elements(
          elements,
        ),
      ),
    );
  }
}

class _Elements extends StatelessWidget {
  final List<WidgetScreenData> elements;
  const _Elements(this.elements);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: elements
          .map(
            (arhitectureElement) => Positioned(
              left: arhitectureElement.position.dx,
              top: arhitectureElement.position.dy,
              child: Container(
                width: arhitectureElement.size.width,
                height: arhitectureElement.size.height,
                decoration: BoxDecoration(
                  color: Colors.blue[800]!.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    arhitectureElement.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
