import 'package:bloc/bloc.dart';
import 'package:esae_monie/enums/validator_error.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'netflix_event.dart';
part 'netflix_state.dart';
part 'netflix_bloc.freezed.dart';

class NetflixBloc extends Bloc<NetflixEvent, NetflixState> {
  NetflixBloc() : super(const NetflixState()) {
    on<_FirstNameChanged>(_firstNameChanged);
    on<_LastNameChanged>(_lastNameChanged);
    on<_AddressChanged>(_addressChanged);
    on<_PostalCodeChanged>(_postalCodeChanged);
    on<_CityChanged>(_cityChanged);
    on<_CountryChanged>(_countryChanged);
    on<_CardHolderNameChanged>(_cardHolderNameChanged);
    on<_CardNumberChanged>(_cardNumberChanged);
    on<_ExpiryChanged>(_expiryChanged);
    on<_CvvChanged>(_cvvChanged);
    on<_Submit>(_submit);
  }

  void _firstNameChanged(_FirstNameChanged event, Emitter<NetflixState> emit) {
    final firstName = FirstNameFormz.dirty(event.firstName);
    emit(
      state.copyWith(
        firstName: firstName.isValid
            ? firstName
            : FirstNameFormz.pure(event.firstName),
      ),
    );
  }

  void _lastNameChanged(_LastNameChanged event, Emitter<NetflixState> emit) {
    final lastName = LastNameFormz.dirty(event.lastName);
    emit(
      state.copyWith(
        lastName: lastName.isValid
            ? lastName
            : LastNameFormz.pure(event.lastName),
      ),
    );
  }

  void _addressChanged(_AddressChanged event, Emitter<NetflixState> emit) {
    final address = AddressFormz.dirty(event.address);
    emit(
      state.copyWith(
        address: address.isValid ? address : AddressFormz.pure(event.address),
      ),
    );
  }

  void _postalCodeChanged(
    _PostalCodeChanged event,
    Emitter<NetflixState> emit,
  ) {
    final postalCode = PostalCodeFormz.dirty(event.postalCode);
    emit(
      state.copyWith(
        postalCode: postalCode.isValid
            ? postalCode
            : PostalCodeFormz.pure(event.postalCode),
      ),
    );
  }

  void _cityChanged(_CityChanged event, Emitter<NetflixState> emit) {
    final city = CityFormz.dirty(event.city);
    emit(
      state.copyWith(city: city.isValid ? city : CityFormz.pure(event.city)),
    );
  }

  void _countryChanged(_CountryChanged event, Emitter<NetflixState> emit) {
    final country = CountryFormz.dirty(event.country);
    emit(
      state.copyWith(
        country: country.isValid ? country : CountryFormz.pure(event.country),
      ),
    );
  }

  void _cardHolderNameChanged(
    _CardHolderNameChanged event,
    Emitter<NetflixState> emit,
  ) {
    final cardHolder = CardHolderFormz.dirty(event.name);
    emit(
      state.copyWith(
        cardHolderName: cardHolder.isValid
            ? cardHolder
            : CardHolderFormz.pure(event.name),
      ),
    );
  }

  void _cardNumberChanged(
    _CardNumberChanged event,
    Emitter<NetflixState> emit,
  ) {
    final cardNumber = CardNumberFormz.dirty(event.number);
    emit(
      state.copyWith(
        cardNumber: cardNumber.isValid
            ? cardNumber
            : CardNumberFormz.pure(event.number),
      ),
    );
  }

  void _expiryChanged(_ExpiryChanged event, Emitter<NetflixState> emit) {
    final expiry = ExpiryFormz.dirty(event.mmyy);
    emit(
      state.copyWith(
        expiry: expiry.isValid ? expiry : ExpiryFormz.pure(event.mmyy),
      ),
    );
  }

  void _cvvChanged(_CvvChanged event, Emitter<NetflixState> emit) {
    final cvv = CvvFormz.dirty(event.cvv);
    emit(state.copyWith(cvv: cvv.isValid ? cvv : CvvFormz.pure(event.cvv)));
  }

  Future<void> _submit(_Submit event, Emitter<NetflixState> emit) async {
    if (!state.isFormValid) {
      emit(state.copyWith(errorMessage: "Please fill all fields correctly."));
      return;
    }

    emit(state.copyWith(formStatus: FormzSubmissionStatus.inProgress));
  }
}
