enum ValidationError { invalid, small, large, empty, short }

extension ValidationErrorExtension on ValidationError {
  String message(String field) {
    switch (this) {
      case ValidationError.invalid:
        return '$field is invalid';
      case ValidationError.small:
        return '$field is too small';
      case ValidationError.large:
        return '$field is too large';
      case ValidationError.empty:
        return '$field is empty';
      case ValidationError.short:
        return '$field is too short';
    }
  }

  String messageWith(
    String field, {
    String? invalid,
    String? small,
    String? large,
    String? empty,
    String? short,
  }) {
    switch (this) {
      case ValidationError.invalid:
        return invalid ?? message(field);
      case ValidationError.small:
        return small ?? message(field);
      case ValidationError.large:
        return large ?? message(field);
      case ValidationError.empty:
        return empty ?? message(field);
      case ValidationError.short:
        return short ?? message(field);
    }
  }
}
