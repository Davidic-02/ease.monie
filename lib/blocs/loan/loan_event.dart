part of 'loan_bloc.dart';

@freezed
abstract class LoanEvent with _$LoanEvent {
  const factory LoanEvent() = _LoanEvent;
  const factory LoanEvent.nameChanged(String name) = _NameChanged;
  const factory LoanEvent.cnicChanged(String cnic) = _CnicChanged;
  const factory LoanEvent.mobileChanged(String mobile) = _MobileChanged;
  const factory LoanEvent.passwordChanged(String password) = _PasswordChanged;
  const factory LoanEvent.planSelected(String plan) = _PlanSelected;
  const factory LoanEvent.submit() = _Submit;
}
