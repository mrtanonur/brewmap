import 'package:brewmap/dependency_injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataProvider {
  final FirebaseAuth _firebaseAuth = sl.get<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = sl.get<FirebaseFirestore>();
  final String _userCollection = "user";

  Future authCheck() async {
    User? user = _firebaseAuth.currentUser;
    return user;
  }

  Future<Either<String, UserCredential>> signUp(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser?.sendEmailVerification();

      return Right(userCredential);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, void>> storeUserData(
    String id,
    Map<String, dynamic> userdata,
  ) async {
    try {
      await _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .set(userdata);
      return const Right(null);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, void>> sendEmailVerificationLink() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
      return Right(null);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, UserCredential>> signIn(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return Right(userCredential);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, Map<String, dynamic>>> getUserData() async {
    try {
      String id = _firebaseAuth.currentUser!.uid;
      final response = await _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .get();

      return Right(response.data()!);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, void>> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return Right(null);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return Right(null);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }
}
