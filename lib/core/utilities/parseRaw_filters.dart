Map<String, dynamic> parseRawFilters(Map<String, dynamic>? filters) {
  final Map<String, dynamic> rawFilters = {};
  filters?.forEach((key, value) {
    if (value == null) {
      rawFilters[key] = null;
    } else if (value is List) {
      // Handle multiselect: extract .value from each FilterOptionModel
      rawFilters[key] = value
          .where((item) =>
              item != null &&
              item.runtimeType.toString().contains('FilterOptionModel'))
          .map((item) => item.value)
          .toList();
    } else if (value.runtimeType.toString().contains('FilterOptionModel')) {
      rawFilters[key] = value.value;
    } else {
      rawFilters[key] = value;
    }
  });
  return rawFilters;
}
