import 'package:deferred_indexed_stack/deferred_indexed_stack.dart';
import 'package:example/dashboard_tab.dart';
import 'package:flutter/material.dart';

import 'some_layout.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  final _controller = DeferredIndexedStackController();
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        onTap: (value) => setState(() {
          _index = value;
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new_sharp),
            label: "Home",
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarms),
            label: "Tab A",
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit_outlined),
            label: "Tab B",
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.align_horizontal_left_outlined),
            label: "Tab C",
            backgroundColor: Colors.deepPurple,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: DeferredIndexedStack(
              controller: _controller,
              index: _index,
              children: [
                // This tab is not deferred
                DashboardTab(stackController: _controller),

                // This tab will initialize when opened by user
                // or by _controller.initChildById('tab_a')
                // or by _controller.initChildAt(1)
                const DeferredTab(
                  id: 'tab_a',
                  child: SomeLayout(
                    name: 'Tab A',
                    text: "Deferred tab A",
                  ),
                ),

                // This tab will initialize when opened by user
                // or after 10 seconds
                // or by _controller.initChildById('tab_b')
                // or by _controller.initChildAt(2)
                const DeferredTab(
                  id: 'tab_b',
                  deferredFor: Duration(seconds: 10),
                  child: SomeLayout(
                    name: 'Tab B',
                    text: "Init on button click or 10 seconds",
                  ),
                ),

                // This tab will initialize when opened by user
                const DeferredTab(
                  child: SomeLayout(
                    name: 'Tab C',
                    text: "This tab initializes when opened",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
