[![Pub](https://img.shields.io/pub/v/deferred_indexed_stack.svg)](https://pub.dev/packages/deferred_indexed_stack)

This package is an alternative to `IndexedStack`, that supports lazy loading with some additional customization.

## Features

- Defer initialization of specific tabs until user opens them  
- Explicitly set the defer duration of some tabs  
- Explicitly initialize some tabs when needed  

## Usage

```
deferred_indexed_stack: ^0.0.4
```

```dart
final _controller = DeferredIndexedStackController();

...

DeferredIndexedStack(
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
)
```

You can read more in [this Medium article](https://medium.com/@pomis172/improving-the-performance-of-flutter-apps-by-deferring-navigation-tabs-b0eb749d8f96).

## Maintainer

Developed as an open source contribution of [Lifeyear](https://lifeyear.com)