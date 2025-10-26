import 'package:brewmap/dependency_injection.dart';
import 'package:brewmap/features/maps/data/remote_data_providers/maps_remote_data_provider.dart';
import 'package:brewmap/features/maps/models/cafe_model.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsRepository {
  final MapsRemoteDataProvider _mapsRemoteDataProvider = sl
      .get<MapsRemoteDataProvider>();

  Future<Either<String, List<CafeModel>>> getNearbyCafes(
    double latitude,
    double longitude,
  ) async {
    final response = await _mapsRemoteDataProvider.getNearbyCafes(
      latitude,
      longitude,
    );
    return response.fold(
      (Object object) {
        return Left(object.toString());
      },
      (List<dynamic> list) {
        List<CafeModel> cafeList = list
            .map((cafe) => CafeModel.fromJson(cafe))
            .toList();

        return Right(cafeList);
      },
    );
  }

  Future<Either<String, List<LatLng>>> getDirection(
    double latitude,
    double longitude,
    LatLng destination,
  ) async {
    final LatLng origin = LatLng(latitude, longitude);
    final response = await _mapsRemoteDataProvider.getDirection(
      origin,
      destination,
    );

    return response.fold(
      (String errorMessage) {
        return Left(errorMessage);
      },
      (List<PointLatLng>? pointList) {
        final list = pointList!
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();

        return Right(list);
      },
    );
  }
}
