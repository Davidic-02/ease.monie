part of 'netflix_bloc.dart';

@freezed
abstract class NetflixState with _$NetflixState {
  const NetflixState._();

  const factory NetflixState({
    @Default(FirstNameFormz.pure()) FirstNameFormz firstName,
    @Default(LastNameFormz.pure()) LastNameFormz lastName,
    @Default(AddressFormz.pure()) AddressFormz address,
    @Default(PostalCodeFormz.pure()) PostalCodeFormz postalCode,
    @Default(RegionFormz.pure()) RegionFormz state,
    @Default(CityFormz.pure()) CityFormz city,
    @Default(CountryFormz.pure()) CountryFormz country,
    @Default(CardHolderFormz.pure()) CardHolderFormz cardHolderName,
    @Default(CardNumberFormz.pure()) CardNumberFormz cardNumber,
    @Default(ExpiryFormz.pure()) ExpiryFormz expiry,
    @Default(CvvFormz.pure()) CvvFormz cvv,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus formStatus,
    String? errorMessage,
  }) = _NetflixState;

  bool get isFormValid => Formz.validate([
    firstName,
    lastName,
    address,
    postalCode,
    state,
    city,
    country,
    cardHolderName,
    cardNumber,
    expiry,
    cvv,
  ]);
}

// First Name
class FirstNameFormz extends FormzInput<String, ValidationError> {
  const FirstNameFormz.pure([super.value = '']) : super.pure();
  const FirstNameFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    if (value.trim().length < 2) return ValidationError.short;
    return null;
  }
}

class LastNameFormz extends FormzInput<String, ValidationError> {
  const LastNameFormz.pure([super.value = '']) : super.pure();
  const LastNameFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    if (value.trim().length < 2) return ValidationError.short;
    return null;
  }
}

class AddressFormz extends FormzInput<String, ValidationError> {
  const AddressFormz.pure([super.value = '']) : super.pure();
  const AddressFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    return null;
  }
}

class PostalCodeFormz extends FormzInput<String, ValidationError> {
  const PostalCodeFormz.pure([super.value = '']) : super.pure();
  const PostalCodeFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    if (!RegExp(r'^\d{4,6}$').hasMatch(value.trim())) {
      return ValidationError.invalid;
    }
    return null;
  }
}

class RegionFormz extends FormzInput<String, ValidationError> {
  const RegionFormz.pure([super.value = '']) : super.pure();
  const RegionFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    return null;
  }
}

class CityFormz extends FormzInput<String, ValidationError> {
  const CityFormz.pure([super.value = '']) : super.pure();
  const CityFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    return null;
  }
}

class CountryFormz extends FormzInput<String, ValidationError> {
  const CountryFormz.pure([super.value = '']) : super.pure();
  const CountryFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    return null;
  }
}

class CardHolderFormz extends FormzInput<String, ValidationError> {
  const CardHolderFormz.pure([super.value = '']) : super.pure();
  const CardHolderFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    return null;
  }
}

class CardNumberFormz extends FormzInput<String, ValidationError> {
  const CardNumberFormz.pure([super.value = '']) : super.pure();
  const CardNumberFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    if (!RegExp(r'^\d{16}$').hasMatch(value.replaceAll(' ', ''))) {
      return ValidationError.invalid;
    }
    return null;
  }
}

class ExpiryFormz extends FormzInput<String, ValidationError> {
  const ExpiryFormz.pure([super.value = '']) : super.pure();
  const ExpiryFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value.trim())) {
      return ValidationError.invalid;
    }
    return null;
  }
}

class CvvFormz extends FormzInput<String, ValidationError> {
  const CvvFormz.pure([super.value = '']) : super.pure();
  const CvvFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    if (!RegExp(r'^\d{3,4}$').hasMatch(value.trim())) {
      return ValidationError.invalid;
    }
    return null;
  }
}
