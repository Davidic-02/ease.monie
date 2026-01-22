import 'package:esae_monie/enums/validator_error.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:formz/formz.dart';

part 'gift_event.dart';
part 'gift_state.dart';
part 'gift_bloc.freezed.dart';

class GiftBloc extends Bloc<GiftEvent, GiftState> {
  GiftBloc() : super(const GiftState()) {
    on<_Started>(_onStarted);
    on<_SelectGift>(_onSelectGift);
    on<_RecipientNameChanged>(_onRecipientNameChanged);
    on<_AccountNumberChanged>(_onAccountNumberChanged);
    on<_PurposeChanged>(_onPurposeChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_GiftAmountChanged>(_onGiftAmountChanged);
    on<_GiftMessageChanged>(_onGiftMessageChanged);
    on<_QuickAmountSelected>(_onQuickAmountSelected);
    on<_SubmitGift>(_onSubmitGift);
    on<_ResetGift>(_onResetGift);
  }
}
