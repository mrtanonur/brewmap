import 'package:bloc/bloc.dart';
import 'package:brewmap/dependency_injection.dart';
import 'package:brewmap/features/auth/data/repositories/auth_repository.dart';
import 'package:brewmap/features/auth/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository = sl.get<AuthRepository>();
  AuthCubit() : super(AuthState.initial());

  Future authCheck() async {
    final response = await _repository.authCheck();
    if (response) {
      emit(state.copyWith(status: AuthStatus.userExists));
    } else {
      emit(state.copyWith(status: AuthStatus.signUp));
    }
  }

  Future signUp(String email, String password) async {
    final response = await _repository.signUp(email, password);
    response.fold(
      (String failureMessage) {
        emit(state.copyWith(error: failureMessage, status: AuthStatus.failure));
      },
      (UserModel userModel) {
        emit(
          state.copyWith(
            status: AuthStatus.verificationProcess,
            userData: userModel,
          ),
        );
      },
    );
  }

  Future storeUserData() async {
    final response = await _repository.storeUserData(state.userData!);
    response.fold((String failureMessage) {
      emit(state.copyWith(error: failureMessage, status: AuthStatus.failure));
    }, (_) {});
  }

  Future sendEmailVerificationLink() async {
    final response = await _repository.sendEmailVerificationLink();

    response.fold(
      (String failureMessage) {
        emit(state.copyWith(error: failureMessage, status: AuthStatus.failure));
      },
      (_) {
        emit(state.copyWith(status: AuthStatus.verificationProcess));
      },
    );
  }

  Future signIn(String email, String password) async {
    final response = await _repository.signIn(email, password);
    response.fold(
      (String failureMessage) {
        emit(state.copyWith(error: failureMessage, status: AuthStatus.failure));
      },
      (User? user) {
        if (user != null) {
          if (user.emailVerified) {
            // getUserData();
            emit(state.copyWith(status: AuthStatus.signIn));
          } else {
            emit(state.copyWith(status: AuthStatus.unVerified));
          }
        } else {
          emit(state.copyWith(status: AuthStatus.failure));
        }
      },
    );
  }

  Future getUserData() async {
    final response = await _repository.getUserData();

    response.fold(
      (String failureMessage) {
        emit(state.copyWith(error: failureMessage, status: AuthStatus.failure));
      },
      (UserModel userModel) {
        emit(state.copyWith(userData: userModel));
      },
    );
  }

  Future resetPassword(String email) async {
    final response = await _repository.resetPassword(email);
    response.fold(
      (String failureMessage) {
        emit(state.copyWith(error: failureMessage, status: AuthStatus.failure));
      },
      (_) {
        emit(state.copyWith(status: AuthStatus.resetPassword));
      },
    );
  }

  Future signOut() async {
    final response = await _repository.signOut();
    response.fold(
      (String failureMessage) {
        emit(state.copyWith(error: failureMessage, status: AuthStatus.failure));
      },
      (_) {
        emit(state.copyWith(status: AuthStatus.signOut));
      },
    );
  }
}
