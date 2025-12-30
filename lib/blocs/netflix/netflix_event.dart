part of 'netflix_bloc.dart';

@freezed
abstract class NetflixEvent with _$NetflixEvent {
  const factory NetflixEvent.firstNameChanged(String firstName) =
      _FirstNameChanged;
  const factory NetflixEvent.lastNameChanged(String lastName) =
      _LastNameChanged;
  const factory NetflixEvent.addressChanged(String address) = _AddressChanged;
  const factory NetflixEvent.postalCodeChanged(String postalCode) =
      _PostalCodeChanged;
  const factory NetflixEvent.cityChanged(String city) = _CityChanged;
  const factory NetflixEvent.countryChanged(String country) = _CountryChanged;

  const factory NetflixEvent.cardHolderNameChanged(String name) =
      _CardHolderNameChanged;
  const factory NetflixEvent.cardNumberChanged(String number) =
      _CardNumberChanged;
  const factory NetflixEvent.expiryChanged(String mmyy) = _ExpiryChanged;
  const factory NetflixEvent.cvvChanged(String cvv) = _CvvChanged;

  const factory NetflixEvent.submit() = _Submit;
}
