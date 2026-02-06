import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/models/insurance_model.dart';
import 'package:esae_monie/enums/validator_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:formz/formz.dart';

part 'insurance_event.dart';
part 'insurance_state.dart';
part 'insurance_bloc.freezed.dart';

class InsuranceBloc extends Bloc<InsuranceEvent, InsuranceState> {
  InsuranceBloc() : super(const InsuranceState()) {
    on<_Init>(_init);
    on<_SelectInsurance>(_onSelectInsurance);
    on<_InsurancePlanChanged>(_onInsurancePlanChanged);

    on<_FirstNameChanged>(_onFirstNameChanged);
    on<_LastNameChanged>(_onLastNameChanged);
    on<_FamilyMembersChanged>(_onFamilyMembersChanged);
    on<_PurposeChanged>(_onPurposeChanged);

    on<_PaymentPlanChanged>(_onPaymentPlanChanged);
    on<_PasswordChanged>(_onPasswordChanged);

    on<_CardNameChanged>(_onCardNameChanged);
    on<_CardNumberChanged>(_onCardNumberChanged);
    on<_CardExpiryChanged>(_onCardExpiryChanged);
    on<_CardCvvChanged>(_onCardCvvChanged);

    on<_SubmitInsurance>(_onSubmitInsurance);
    on<_ResetInsurance>(_onResetInsurance);
    add(_Init());
  }

  void _init(_Init event, Emitter<InsuranceState> emit) {
    emit(state.copyWith(insuranceModel: insuranceModel));
  }

  // Select service
  void _onSelectInsurance(
    _SelectInsurance event,
    Emitter<InsuranceState> emit,
  ) {
    emit(state.copyWith(selectedInsuranceId: event.insuranceId));
  }

  // Select insurance plan
  void _onInsurancePlanChanged(
    _InsurancePlanChanged event,
    Emitter<InsuranceState> emit,
  ) {
    emit(state.copyWith(selectedInsurancePlan: event.plan));
  }

  // Personal info
  void _onFirstNameChanged(
    _FirstNameChanged event,
    Emitter<InsuranceState> emit,
  ) {
    emit(state.copyWith(firstName: FirstNameFormz.dirty(event.value)));
  }

  void _onLastNameChanged(
    _LastNameChanged event,
    Emitter<InsuranceState> emit,
  ) {
    emit(state.copyWith(lastName: LastNameFormz.dirty(event.value)));
  }

  void _onFamilyMembersChanged(
    _FamilyMembersChanged event,
    Emitter<InsuranceState> emit,
  ) {
    emit(state.copyWith(familyMembers: FamilyMembersFormz.dirty(event.value)));
  }

  void _onPurposeChanged(_PurposeChanged event, Emitter<InsuranceState> emit) {
    emit(state.copyWith(purpose: PurposeFormz.dirty(event.value)));
  }

  // Payment info
  void _onPaymentPlanChanged(
    _PaymentPlanChanged event,
    Emitter<InsuranceState> emit,
  ) {
    emit(state.copyWith(paymentPlan: PaymentPlanFormz.dirty(event.value)));
  }

  void _onPasswordChanged(
    _PasswordChanged event,
    Emitter<InsuranceState> emit,
  ) {
    emit(state.copyWith(password: PasswordFormz.dirty(event.value)));
  }

  void _onCardNameChanged(
    _CardNameChanged event,
    Emitter<InsuranceState> emit,
  ) {
    emit(state.copyWith(cardName: CardNameFormz.dirty(event.value)));
  }

  void _onCardNumberChanged(
    _CardNumberChanged event,
    Emitter<InsuranceState> emit,
  ) {
    emit(state.copyWith(cardNumber: CardNumberFormz.dirty(event.value)));
  }

  void _onCardExpiryChanged(
    _CardExpiryChanged event,
    Emitter<InsuranceState> emit,
  ) {
    emit(state.copyWith(expiry: CardExpiryFormz.dirty(event.value)));
  }

  void _onCardCvvChanged(_CardCvvChanged event, Emitter<InsuranceState> emit) {
    emit(state.copyWith(cvv: CardCvvFormz.dirty(event.value)));
  }

  // Submit
  Future<void> _onSubmitInsurance(
    _SubmitInsurance event,
    Emitter<InsuranceState> emit,
  ) async {
    if (state.submissionStatus == FormzSubmissionStatus.inProgress) return;

    if (!state.isInsuranceFormValid) {
      emit(
        state.copyWith(
          firstName: FirstNameFormz.dirty(state.firstName.value),
          lastName: LastNameFormz.dirty(state.lastName.value),
          familyMembers: FamilyMembersFormz.dirty(state.familyMembers.value),
          purpose: PurposeFormz.dirty(state.purpose.value),
          paymentPlan: PaymentPlanFormz.dirty(state.paymentPlan.value),
          password: PasswordFormz.dirty(state.password.value),
          cardName: CardNameFormz.dirty(state.cardName.value),
          cardNumber: CardNumberFormz.dirty(state.cardNumber.value),
          expiry: CardExpiryFormz.dirty(state.expiry.value),
          cvv: CardCvvFormz.dirty(state.cvv.value),
          errorMessage: 'Please fill in all fields correctly.',
        ),
      );
      return;
    }

    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          submissionStatus: FormzSubmissionStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  // Reset
  void _onResetInsurance(_ResetInsurance event, Emitter<InsuranceState> emit) {
    emit(
      state.copyWith(
        selectedInsuranceId: null,
        selectedInsurancePlan: null,
        firstName: const FirstNameFormz.pure(),
        lastName: const LastNameFormz.pure(),
        familyMembers: const FamilyMembersFormz.pure(),
        purpose: const PurposeFormz.pure(),
        paymentPlan: const PaymentPlanFormz.pure(),
        password: const PasswordFormz.pure(),
        cardName: const CardNameFormz.pure(),
        cardNumber: const CardNumberFormz.pure(),
        expiry: const CardExpiryFormz.pure(),
        cvv: const CardCvvFormz.pure(),
        submissionStatus: FormzSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }
}
