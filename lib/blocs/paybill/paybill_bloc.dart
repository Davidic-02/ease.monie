import 'package:esae_monie/enums/validator_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:formz/formz.dart';

part 'paybill_event.dart';
part 'paybill_state.dart';
part 'paybill_bloc.freezed.dart';

class PayBillBloc extends Bloc<PayBillEvent, PayBillState> {
  PayBillBloc() : super(const PayBillState()) {
    on<_BillTypeChanged>(_billTypeChanged);
    on<_NameChanged>(_nameChanged);
    on<_AccountNumberChanged>(_accountNumberChanged);
    on<_PasswordChanged>(_passwordChanged);
    on<_ProviderChanged>(_providerChanged);
    on<_MeterNumberChanged>(_meterNumberChanged);
    on<_CustomerIdChanged>(_customerIdChanged);
    on<_Submit>(_submit);
    on<_SubmitSuccessful>(_submitSuccessful);
    on<_SubmitFailed>(_submitFailed);
    on<_ErrorMessage>(_errorMessage);
    on<_OtherBillChanged>(_otherBill);
  }

  void _billTypeChanged(_BillTypeChanged event, Emitter<PayBillState> emit) {
    var newState = state.copyWith(selectedBill: event.billType);

    switch (state.selectedBill) {
      case 'Internet':
        newState = newState.copyWith(
          internetName: NameFormz.pure(''),
          accountNumber: AccountNumberFormz.pure(''),
          password: BillPasswordFormz.pure(''),
        );
        break;
      case 'Electricity':
        newState = newState.copyWith(
          provider: ProviderFormz.pure(''),
          meterNumber: MeterNumberFormz.pure(''),
        );
        break;
      case 'Water':
        newState = newState.copyWith(customerId: CustomerIdFormz.pure(''));
        break;
      case 'Others':
        newState = newState.copyWith(otherBill: OtherBillFormz.pure(''));
        break;
    }
    emit(newState);
  }

  void _nameChanged(_NameChanged event, Emitter<PayBillState> emit) {
    final name = NameFormz.dirty(event.name);
    emit(
      state.copyWith(
        internetName: name.isValid ? name : NameFormz.pure(event.name),
      ),
    );
  }

  void _accountNumberChanged(
    _AccountNumberChanged event,
    Emitter<PayBillState> emit,
  ) {
    final accountNumber = AccountNumberFormz.dirty(event.accountNumber);
    emit(
      state.copyWith(
        accountNumber: accountNumber.isValid
            ? accountNumber
            : AccountNumberFormz.pure(event.accountNumber),
      ),
    );
  }

  void _passwordChanged(_PasswordChanged event, Emitter<PayBillState> emit) {
    final password = BillPasswordFormz.dirty(event.password);
    emit(
      state.copyWith(
        password: password.isValid
            ? password
            : BillPasswordFormz.pure(event.password),
      ),
    );
  }

  void _providerChanged(_ProviderChanged event, Emitter<PayBillState> emit) {
    final provider = ProviderFormz.dirty(event.provider);
    emit(
      state.copyWith(
        provider: provider.isValid
            ? provider
            : ProviderFormz.pure(event.provider),
      ),
    );
  }

  void _meterNumberChanged(
    _MeterNumberChanged event,
    Emitter<PayBillState> emit,
  ) {
    final meterNumber = MeterNumberFormz.dirty(event.meterNumber);
    emit(
      state.copyWith(
        meterNumber: meterNumber.isValid
            ? meterNumber
            : MeterNumberFormz.pure(event.meterNumber),
      ),
    );
  }

  void _customerIdChanged(
    _CustomerIdChanged event,
    Emitter<PayBillState> emit,
  ) {
    final customerId = CustomerIdFormz.dirty(event.customerId);
    emit(
      state.copyWith(
        customerId: customerId.isValid
            ? customerId
            : CustomerIdFormz.pure(event.customerId),
      ),
    );
  }

  void _otherBill(_OtherBillChanged event, Emitter<PayBillState> emit) {
    final otherBill = OtherBillFormz.dirty(event.otherBill);
    emit(state.copyWith(otherBill: otherBill));
  }

  void _submit(_Submit event, Emitter<PayBillState> emit) {
    if (state.billSubmissionStatus == FormzSubmissionStatus.inProgress) return;

    bool isValid;
    switch (state.selectedBill) {
      case 'Internet':
        isValid = state.isInternetFormValid;
        break;
      case 'Electricity':
        isValid = state.isElectricityFormValid;
        break;
      case 'Water':
        isValid = state.isWaterFormValid;
        break;
      case 'Others':
        isValid = state.isOthersFormValid;
        break;
      default:
        isValid = false;
    }

    if (!isValid) {
      if (state.selectedBill == 'Internet') {
        emit(
          state.copyWith(
            internetName: NameFormz.dirty(state.internetName.value),
            accountNumber: AccountNumberFormz.dirty(state.accountNumber.value),
            password: BillPasswordFormz.dirty(state.password.value),
            errorMessage: "Fix highlighted errors",
            billSubmissionStatus: FormzSubmissionStatus.failure,
          ),
        );
        return;
      }

      if (state.selectedBill == 'Electricity') {
        emit(
          state.copyWith(
            provider: ProviderFormz.dirty(state.provider.value),
            meterNumber: MeterNumberFormz.dirty(state.meterNumber.value),
            errorMessage: "Fix highlighted errors",
            billSubmissionStatus: FormzSubmissionStatus.failure,
          ),
        );
        return;
      }

      if (state.selectedBill == 'Water') {
        emit(
          state.copyWith(
            customerId: CustomerIdFormz.dirty(state.customerId.value),
            errorMessage: "Fix highlighted errors",
            billSubmissionStatus: FormzSubmissionStatus.failure,
          ),
        );
        return;
      }

      if (state.selectedBill == 'Others') {
        emit(
          state.copyWith(
            internetName: NameFormz.dirty(state.internetName.value),
            errorMessage: "Fix highlighted errors",
            billSubmissionStatus: FormzSubmissionStatus.failure,
          ),
        );
        return;
      }
    }

    emit(
      state.copyWith(billSubmissionStatus: FormzSubmissionStatus.inProgress),
    );
    add(const PayBillEvent.submitSuccessful());
  }

  void _submitSuccessful(_SubmitSuccessful event, Emitter<PayBillState> emit) {
    emit(
      state.copyWith(
        billSubmissionStatus: FormzSubmissionStatus.success,
        errorMessage: null,
      ),
    );
  }

  void _submitFailed(_SubmitFailed event, Emitter<PayBillState> emit) {
    emit(
      state.copyWith(
        billSubmissionStatus: FormzSubmissionStatus.failure,
        errorMessage: 'Please fill in all field correctly',
      ),
    );
  }

  void _errorMessage(_ErrorMessage event, Emitter<PayBillState> emit) {
    emit(state.copyWith(billSubmissionStatus: FormzSubmissionStatus.failure));
  }
}
