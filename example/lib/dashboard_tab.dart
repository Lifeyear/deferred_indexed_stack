import 'package:deferred_indexed_stack/deferred_indexed_stack.dart';
import 'package:flutter/material.dart';

class DashboardTab extends StatefulWidget {
  final DeferredIndexedStackController stackController;

  const DashboardTab({super.key, required this.stackController});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  late final _HomeTabStore _store =
      _HomeTabStore(stackController: widget.stackController)..init();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This is Dashboard Tab. It emulates fetching some data and after that it explicitly initializes Tab A",
          ),
          ListenableBuilder(
            listenable: _store,
            builder: (context, child) {
              if (!_store.isLoaded) {
                return const Center(child: CircularProgressIndicator());
              }
              return Text("Dashboard data is loaded. Tab A is initialized.");
            },
          ),
          Text(
            "Tab B is deferred for 10 seconds or you can explicitly init it by clicking on the button below. Or by opening it.",
          ),
          ElevatedButton(
            onPressed: () {
              widget.stackController.initChildById("tab_b");
            },
            child: Text("Initialize Tab B"),
          ),
        ],
      ),
    );
  }
}

class _HomeTabStore extends ChangeNotifier {
  _HomeTabStore({required this.stackController});

  final DeferredIndexedStackController stackController;

  bool isLoaded = false;

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 3));
    isLoaded = true;
    stackController.initChildById('tab_a');
    notifyListeners();
  }
}
