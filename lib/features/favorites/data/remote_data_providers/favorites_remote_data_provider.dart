import 'package:brewmap/dependency_injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesRemoteDataProvider {
  final FirebaseAuth _firebaseAuth = sl.get<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = sl.get<FirebaseFirestore>();

  final String _userCollection = "user";
  final String _favoriteCollection = "favorite";

  Future<Either<String, void>> addFavorite(
    String cafeId,
    Map<String, dynamic> json,
  ) async {
    try {
      String id = _firebaseAuth.currentUser!.uid;
      _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .collection(_favoriteCollection)
          .doc(cafeId)
          .set(json);

      return Right(null);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, void>> removeFavorite(String cafeId) async {
    try {
      String id = _firebaseAuth.currentUser!.uid;
      await _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .collection(_favoriteCollection)
          .doc(cafeId)
          .delete();
      return const Right(null);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, List<Map<String, dynamic>>>> getFavorites() async {
    try {
      String id = _firebaseAuth.currentUser!.uid;
      final snapshot = await _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .collection(_favoriteCollection)
          .get();
      List<Map<String, dynamic>> favoritesMap = snapshot.docs
          .map((doc) => doc.data())
          .toList();

      return Right(favoritesMap);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }
}
