import 'package:flutter/material.dart';

class RefreshButton extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final String tooltip;
  final bool forceLoading;

  const RefreshButton({super.key, this.onPressed, required this.tooltip, this.forceLoading = false});

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
    if (widget.forceLoading) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (widget.onPressed == null) {
      return;
    }

    if (!widget.forceLoading) {
      _controller.repeat();
    }

    await widget.onPressed!();

    if (!widget.forceLoading) {
      _controller.stop();
    }
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

