part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  signUp,
  userExists,
  verificationProcess,
  unVerified,
  signIn,
  resetPassword,
  signOut,
  failure,
}

class AuthState extends Equatable {
  final UserModel? userData;
  final AuthStatus? status;
  final String? error;
  const AuthState({this.userData, this.status, this.error});

  AuthState copyWith({UserModel? userData, AuthStatus? status, String? error}) {
    return AuthState(
      userData: userData ?? this.userData,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  factory AuthState.initial() {
    return AuthState(status: AuthStatus.initial);
  }

  @override
  List<Object?> get props => [userData, status, error];
}
