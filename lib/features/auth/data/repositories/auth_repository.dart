import 'package:brewmap/dependency_injection.dart';
import 'package:brewmap/features/auth/data/data_providers/remote_data_providers/auth_remote_data_provider.dart';
import 'package:brewmap/features/auth/models/user_model.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthRemoteDataProvider _authRemoteDataProvider = sl
      .get<AuthRemoteDataProvider>();

  Future<bool> authCheck() async {
    User? user = await _authRemoteDataProvider.authCheck();
    if (user != null) {
      if (user.emailVerified) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<Either<String, UserModel>> signUp(
    String email,
    String password,
  ) async {
    final response = await _authRemoteDataProvider.signUp(email, password);
    return response.fold(
      (String failure) {
        return Left(failure);
      },
      (UserCredential userCredential) {
        UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          fullName: userCredential.user!.displayName,
          email: userCredential.user!.email!,
          signInMethod: userCredential.credential?.signInMethod,
        );
        print(userModel.id);
        return Right(userModel);
      },
    );
  }

  Future<Either<String, void>> storeUserData(UserModel userModel) async {
    final response = await _authRemoteDataProvider.storeUserData(
      userModel.id,
      userModel.toJson(),
    );
    return response.fold(
      (String failure) {
        return Left(failure);
      },
      (_) {
        return Right(null);
      },
    );
  }

  Future<Either<String, void>> sendEmailVerificationLink() async {
    return await _authRemoteDataProvider.sendEmailVerificationLink();
  }

  Future<Either<String, User>> signIn(String email, String password) async {
    final response = await _authRemoteDataProvider.signIn(email, password);
    return response.fold(
      (String failure) {
        return Left(failure);
      },
      (UserCredential userCredential) {
        return Right(userCredential.user!);
      },
    );
  }

  Future<Either<String, UserModel>> getUserData() async {
    final response = await _authRemoteDataProvider.getUserData();
    return response.fold(
      (String failure) {
        return Left(failure);
      },
      (Map<String, dynamic> map) {
        UserModel userModel = UserModel.fromJson(map);
        return Right(userModel);
      },
    );
  }

  Future<Either<String, void>> resetPassword(String email) async {
    return await _authRemoteDataProvider.resetPassword(email);
  }

  Future<Either<String, void>> signOut() async {
    return await _authRemoteDataProvider.signOut();
  }
}
