import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esae_monie/models/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseFirestore _firestore;
  UserBloc(this._firestore) : super(const UserState()) {
    on<_LoadUser>(_loadUser);
  }

  void _loadUser(_LoadUser event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await _firestore.collection('users').doc(uid).get();

      if (!snapshot.exists) {
        emit(state.copyWith(isLoading: false, errorMessage: 'User not found'));

        return;
      }

      final user = UserModel.fromJson(snapshot.data()!);

      emit(state.copyWith(errorMessage: null, user: user, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: '$e'.toString()));
    }
  }
}
