import 'package:flutter/material.dart';

class RefreshButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String tooltip;

  const RefreshButton({Key? key, required this.onPressed, required this.tooltip}) : super(key: key);

  @override
  RefreshButtonState createState() => RefreshButtonState();
}

class RefreshButtonState extends State<RefreshButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    _controller.repeat();
    await widget.onPressed();
    _controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: widget.tooltip,
      icon: AnimatedBuilder(
        animation: _controller,
        child: const Icon(Icons.refresh),
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: _controller.value * 2.0 * 3.141592653589793,
            child: child,
          );
        },
      ),
      onPressed: () async {
        await _refresh();
      },
    );
  }
}

