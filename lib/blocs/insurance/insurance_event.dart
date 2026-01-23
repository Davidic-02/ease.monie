part of 'insurance_bloc.dart';

@freezed
abstract class InsuranceEvent with _$InsuranceEvent {
  const factory InsuranceEvent() = _InsuranceEvent;

  /// Load available insurance services
  const factory InsuranceEvent.started(List<ServicesModel> initialServices) =
      _Started;

  /// User selects insurance service (Life, Health, etc.)
  const factory InsuranceEvent.selectInsurance(String insuranceId) =
      _SelectInsurance;

  /// User selects insurance plan (Basic / Premium)
  const factory InsuranceEvent.insurancePlanChanged(InsuranceModel plan) =
      _InsurancePlanChanged;

  /// Personal Information fields
  const factory InsuranceEvent.firstNameChanged(String value) =
      _FirstNameChanged;
  const factory InsuranceEvent.lastNameChanged(String value) = _LastNameChanged;
  const factory InsuranceEvent.familyMembersChanged(String value) =
      _FamilyMembersChanged;
  const factory InsuranceEvent.purposeChanged(String value) = _PurposeChanged;

  /// Card / Payment Details (Formz style)
  const factory InsuranceEvent.cardNameChanged(String value) = _CardNameChanged;
  const factory InsuranceEvent.cardNumberChanged(String value) =
      _CardNumberChanged;
  const factory InsuranceEvent.cardExpiryChanged(String value) =
      _CardExpiryChanged;
  const factory InsuranceEvent.cardCvvChanged(String value) = _CardCvvChanged;

  /// Payment plan selection (Monthly / Quarterly / Yearly)
  const factory InsuranceEvent.paymentPlanChanged(String value) =
      _PaymentPlanChanged;

  /// Password for confirmation
  const factory InsuranceEvent.passwordChanged(String value) = _PasswordChanged;

  /// Submit insurance form
  const factory InsuranceEvent.submitInsurance() = _SubmitInsurance;

  /// Reset the insurance flow
  const factory InsuranceEvent.resetInsurance() = _ResetInsurance;
}
