import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ExampleScaffold extends StatelessWidget {
  const ExampleScaffold({
    super.key,
    this.children = const [],
    this.tags = const [],
    this.title = '',
    this.padding,
  });

  final List<Widget> children;
  final List<String> tags;
  final String title;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                for (final tag in tags) Chip(label: Text(tag)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (padding != null)
            Padding(
              padding: padding!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            )
          else
            ...children,
        ],
      ),
    );
  }
}
