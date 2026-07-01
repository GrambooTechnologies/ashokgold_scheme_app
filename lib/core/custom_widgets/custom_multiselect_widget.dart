import 'package:flutter/material.dart';

class CustomMultiSelectDropdown<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final List<T> selectedItems;
  final String Function(T) displayText;
  final void Function(List<T>) onChanged;

  const CustomMultiSelectDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.displayText,
    required this.onChanged,
  });

  @override
  State<CustomMultiSelectDropdown<T>> createState() =>
      _CustomMultiSelectDropdownState<T>();
}

class _CustomMultiSelectDropdownState<T>
    extends State<CustomMultiSelectDropdown<T>> {
  late List<T> _selectedItems;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _selectedItems = List<T>.from(widget.selectedItems);
  }

  void _onItemTapped(T item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
      widget.onChanged(_selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((item) {
      final label = widget.displayText(item).toLowerCase();
      return label.contains(_searchText.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            border: const OutlineInputBorder(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search field
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchText = val;
                  });
                },
              ),
              const SizedBox(height: 8),
              // List of items with checkboxes, wrapped in a scrollable container to prevent overflow
              SizedBox(
                height: 200, // You can adjust this height as needed
                child: filteredItems.isEmpty
                    ? const Center(
                        child: Text('No items found',
                            style: TextStyle(color: Colors.grey)),
                      )
                    : Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            final isSelected = _selectedItems.contains(item);
                            return CheckboxListTile(
                              value: isSelected,
                              onChanged: (_) => _onItemTapped(item),
                              title: Text(widget.displayText(item)),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
