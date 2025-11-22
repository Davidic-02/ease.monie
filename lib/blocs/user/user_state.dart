part of 'user_bloc.dart';

@freezed
abstract class UserState with _$UserState {
  const UserState._();

  const factory UserState({
    UserModel? user,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _UserState;
}
