enum AppContentType {
  markdown,
  html,
  text,
  unknown,
}

class AppContentTypeParser {
  static AppContentType fromValue(String? value) {
    switch ((value ?? '').toLowerCase().trim()) {
      case 'markdown':
        return AppContentType.markdown;
      case 'html':
        return AppContentType.html;
      case 'text':
        return AppContentType.text;
      default:
        return AppContentType.unknown;
    }
  }
}
