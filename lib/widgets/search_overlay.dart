import 'package:flutter/material.dart';
import '../models/cafe.dart';

class SearchOverlay extends StatefulWidget {
  final List<Cafe> cafes;
  final Function(Cafe) onCafeSelected;
  final VoidCallback onFilterPressed;
  final Function(String) onSearch;

  const SearchOverlay({
    Key? key,
    required this.cafes,
    required this.onCafeSelected,
    required this.onFilterPressed,
    required this.onSearch,
  }) : super(key: key);

  @override
  _SearchOverlayState createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text;
    widget.onSearch(query);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: SearchAnchor(
              builder: (context, controller) {
                return SearchBar(
                  controller: _searchController,
                  constraints: BoxConstraints(
                    minHeight: 40,
                    maxHeight: 40,
                  ),
                  leading: Icon(Icons.search, color: Colors.grey),
                  trailing: [],
                  backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.8)),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onTap: () {
                    controller.openView();
                    _searchController.clear();
                  },
                  onChanged: (_) => controller.openView(),
                  onSubmitted: (value) {
                    _performSearch();
                    controller.closeView(value);
                  },
                  hintText: '카페 검색',
                  hintStyle: MaterialStateProperty.all(
                    TextStyle(color: Colors.grey),
                  ),
                );
              },
              suggestionsBuilder: (context, controller) {
                final query = controller.text.toLowerCase();
                if (query.isEmpty) {
                  return [];
                } else {
                  final filteredCafes = widget.cafes
                      .where((cafe) =>
                          cafe.name.toLowerCase().contains(query) ||
                          cafe.address.toLowerCase().contains(query))
                      .take(5)
                      .toList();

                  return filteredCafes
                      .map((cafe) => ListTile(
                            title: RichText(
                              text: TextSpan(
                                children:
                                    highlightOccurrences(cafe.name, query),
                                style: DefaultTextStyle.of(context).style,
                              ),
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                children: highlightOccurrences(
                                    cafe.address, query),
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ),
                            onTap: () {
                              controller.closeView(cafe.name);
                              _searchController.text = cafe.name;
                              widget.onCafeSelected(cafe);
                            },
                          ))
                      .toList();
                }
              },
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list, color: Colors.grey),
              onPressed: widget.onFilterPressed,
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> highlightOccurrences(String text, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: text)];
    }

    final matches = query.toLowerCase().allMatches(text.toLowerCase());
    int lastMatchEnd = 0;
    final List<TextSpan> children = [];
    for (final match in matches) {
      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
        ));
      }
      children.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      ));
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd != text.length) {
      children.add(TextSpan(
        text: text.substring(lastMatchEnd, text.length),
      ));
    }
    return children;
  }
}