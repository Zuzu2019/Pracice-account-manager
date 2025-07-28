import 'package:flutter/material.dart';

class SearchBarExample extends StatefulWidget {
  final void Function(String) onQueryChanged;

  const SearchBarExample({super.key, required this.onQueryChanged});

  @override
  State<SearchBarExample> createState() => _SearchBarExampleState();
}

class _SearchBarExampleState extends State<SearchBarExample> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            onChanged: widget.onQueryChanged, // Aquí sí se usa widget
            leading: const Icon(Icons.search),
            trailing: const <Widget>[],
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
          );
        },
        suggestionsBuilder: (context, controller) => const <Widget>[],
      ),
    );
  }
}
