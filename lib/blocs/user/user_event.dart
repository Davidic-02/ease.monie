part of 'user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent() = _UserEvent;
  const factory UserEvent.loadUser() = _LoadUser;
}
