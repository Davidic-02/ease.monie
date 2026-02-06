part of 'charity_bloc.dart';

@freezed
abstract class CharityState with _$CharityState {
  const CharityState._();

  const factory CharityState({
    @Default(<String, ServicesModel>{}) Map<String, ServicesModel> charities,

    // Change this to store amount per charity ID
    ServicesModel? servicesModel,
    @Default([]) List<ServicesModel> charityModel,
    @Default(<String, DonationAmountFormz>{})
    Map<String, DonationAmountFormz> donationAmounts,

    @Default(FormzSubmissionStatus.initial)
    FormzSubmissionStatus submissionStatus,
    String? selectedCharityId,
    String? errorMessage,
  }) = _CharityState;
}

class DonationAmountFormz extends FormzInput<String, ValidationError> {
  const DonationAmountFormz.pure([super.value = '']) : super.pure();
  const DonationAmountFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationError.empty;
    }

    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return ValidationError.invalid;
    }

    return null;
  }
}
