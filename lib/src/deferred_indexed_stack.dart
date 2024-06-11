import 'dart:async';

import 'package:flutter/widgets.dart';

class DeferredIndexedStack extends StatefulWidget {
  const DeferredIndexedStack({
    super.key,
    this.controller,
    this.index = 0,
    required this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
  });

  /// Controller to initialize deferred tabs
  final DeferredIndexedStackController? controller;

  /// How to align the non-positioned and partially-positioned children in the
  /// stack.
  ///
  /// Defaults to [AlignmentDirectional.topStart].
  ///
  /// See [Stack.alignment] for more information.
  final AlignmentGeometry alignment;

  /// The text direction with which to resolve [alignment].
  ///
  /// Defaults to the ambient [Directionality].
  final TextDirection? textDirection;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// How to size the non-positioned children in the stack.
  ///
  /// Defaults to [StackFit.loose].
  ///
  /// See [Stack.fit] for more information.
  final StackFit sizing;

  /// The index of the child to show.
  ///
  /// If this is null, none of the children will be shown.
  final int? index;

  /// The child widgets of the stack.
  ///
  /// Only the child at index [index] will be shown.
  ///
  /// See [Stack.children] for more information.
  final List<Widget> children;

  @override
  State<DeferredIndexedStack> createState() => _DeferredIndexedStackState();
}

class _DeferredIndexedStackState extends State<DeferredIndexedStack> {
  late final _controller =
      widget.controller ?? DeferredIndexedStackController();

  @override
  void initState() {
    super.initState();
    _controller.init(widget.children, widget.index ?? 0);
  }

  @override
  void didUpdateWidget(DeferredIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index && widget.index != 0) {
      _controller.initChildAt(widget.index!);
    }
  }

  List<Widget> get children {
    return _controller._initializedIndicies.indexed
        .map((it) => it.$2 ? widget.children[it.$1] : const SizedBox())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return IndexedStack(
          alignment: widget.alignment,
          textDirection: widget.textDirection,
          sizing: widget.sizing,
          index: widget.index,
          clipBehavior: widget.clipBehavior,
          children: children,
        );
      },
    );
  }
}

class DeferredIndexedStackController extends ChangeNotifier {
  late final List<bool> _initializedIndicies;
  final Map<String, int> _idToIndex = {};

  void initChildById(String id) {
    if (_idToIndex[id] == null) return;

    initChildAt(_idToIndex[id]!);
  }

  void initChildAt(int index) {
    final oldValue = _initializedIndicies[index];
    _initializedIndicies[index] = true;
    if (oldValue != _initializedIndicies[index]) {
      notifyListeners();
    }
  }

  void init(List<Widget> children, int index) {
    _initializedIndicies = List.generate(
      children.length,
      (i) => i == index,
    );
    for (int i = 0; i < children.length; i++) {
      if (children[i] case DeferredWidget child) {
        if (child.deferredFor != null) {
          Future.delayed(child.deferredFor!, () {
            initChildAt(i);
          });
        }
        if (child.id != null) {
          _idToIndex[child.id!] = i;
        }
      }
    }
  }
}

class DeferredTab extends StatelessWidget implements DeferredWidget {
  const DeferredTab({
    super.key,
    required this.child,
    this.id,
    this.deferredFor,
  });

  /// Id, which could be used instead of index to initialize the deferred
  /// tabs using controller
  @override
  final String? id;

  /// The amount of time when the tab would be automatically initialized
  @override
  final Duration? deferredFor;

  /// The content of tab
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

abstract class DeferredWidget {
  /// Id, which could be used instead of index to initialize the deferred
  /// tabs using controller
  final String? id;
  
  /// The amount of time when the tab would be automatically initialized
  final Duration? deferredFor;

  DeferredWidget({required this.id, required this.deferredFor});
}
