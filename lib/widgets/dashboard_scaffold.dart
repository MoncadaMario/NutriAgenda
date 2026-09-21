import 'package:flutter/material.dart';

class LoadingScaffold extends StatelessWidget {
  final Color background;
  final Color indicatorColor;

  const LoadingScaffold({
    super.key,
    required this.background,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(child: CircularProgressIndicator(color: indicatorColor)),
    );
  }
}


class RefreshableContent extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final double maxWidth;
  final List<Widget> children;

  const RefreshableContent({
    super.key,
    required this.onRefresh,
    required this.children,
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}