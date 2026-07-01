import 'dart:async';

import 'package:ashokgold_scheme_app/core/custom_widgets/custom_dropdown_normal.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_textfiled.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/models/filter_config_model.dart';
import 'package:flutter/material.dart';

class CustomSearchBarWidget extends StatefulWidget {
  final List<FilterConfigModel> filterConfigs;
  final TextEditingController searchController;
  final void Function(String? searchBy, String? searchValue)? onSearch;

  const CustomSearchBarWidget({
    super.key,
    required this.filterConfigs,
    required this.searchController,
    this.onSearch,
  });

  @override
  State<CustomSearchBarWidget> createState() => _CustomSearchBarWidgetState();
}

class _CustomSearchBarWidgetState extends State<CustomSearchBarWidget> {
  String? selectedSearchBy;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();

    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      widget.onSearch?.call(selectedSearchBy, widget.searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Find configs for searchBy and searchValue
    final searchByConfig = widget.filterConfigs.firstWhere(
      (f) {
        return f.key == "searchBy";
      },
      orElse: () => FilterConfigModel(
        key: "searchBy",
        label: "Search By",
        type: "select",
        options: [],
      ),
    );

    final searchValueConfig = widget.filterConfigs.firstWhere(
      (f) => f.key == "searchValue",
      orElse: () => FilterConfigModel(
        key: "searchValue",
        label: "Search Value",
        type: "text",
      ),
    );

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: CustomTextField(
            label: searchValueConfig.label,
            controller: widget.searchController,
            onChanged: (val) {
              _onSearchChanged();
            },
          ),
        ),

        SizedBox(width: SizeConfig.w(context, 12)),
        Expanded(
          flex: 2,
          child: CustomDropdown(
            hint: "Search By",
            value: selectedSearchBy,
            items: searchByConfig.options != null
                ? searchByConfig.options!
                      .map(
                        (opt) => DropdownMenuItem(
                          value: opt.value,
                          child: Text(
                            opt.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList()
                : [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("No Options"),
                    ),
                  ],
            onChanged: (val) {
              setState(() {
                selectedSearchBy = val;
              });
              _onSearchChanged();
            },
          ),
        ), // Search Value TextField
      ],
    );
  }
}
