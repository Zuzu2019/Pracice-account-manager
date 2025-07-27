import 'package:flutter/material.dart';

class SearchBarExample extends StatefulWidget {
  const SearchBarExample({super.key});

  @override
  State<SearchBarExample> createState() => _SearchBarExampleState();
}

class _SearchBarExampleState extends State<SearchBarExample> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onTap: () => controller.openView(),
            onChanged: (query) {},
            leading: const Icon(Icons.search),
            trailing: const <Widget>[],
          );
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
              return const <Widget>[];
            },
      ),
    );
  }
}
