import 'package:flutter/material.dart';
import '../models/cafe.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List<Cafe> cafes;
  final Function(Cafe) onCafeSelected;
  final VoidCallback onFilterPressed;
  final Function(String) onSearch;

  const SearchAppBar({
    Key? key,
    required this.cafes,
    required this.onCafeSelected,
    required this.onFilterPressed,
    required this.onSearch,
  }) : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 2);
}

class _SearchAppBarState extends State<SearchAppBar> {
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
    return AppBar(
      title: Text('카공여지도'),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: SearchAnchor(
                  builder: (context, controller) {
                    return SearchBar(
                      controller: _searchController,
                      constraints: BoxConstraints(
                        minHeight: 48,
                        maxHeight: 48,
                      ),
                      leading: Icon(Icons.search),
                      trailing: [],
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
                    );
                  },
                  suggestionsBuilder: (context, controller) {
                    final query = controller.text.toLowerCase();
                    if (query.isEmpty) {
                      //검색어가 없을 때 빈 리스트 반환
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
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: widget.onFilterPressed,
                ),
              ),
            ],
          ),
        ),
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
