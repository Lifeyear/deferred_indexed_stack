import 'package:flutter/material.dart';

class SomeLayout extends StatefulWidget {
  final String name;
  final String text;

  const SomeLayout({super.key, required this.name, required this.text});

  @override
  State<SomeLayout> createState() => _SomeLayoutState();
}

class _SomeLayoutState extends State<SomeLayout> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${widget.name} is initialized'),
        ));
      },
    );
    Future.delayed(
      const Duration(milliseconds: 700),
      () {
        setState(() {
          _isLoaded = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(widget.text),
          ),
        ),
      ],
    );
  }
}
