import 'package:brewmap/dependency_injection.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsRemoteDataProvider {
  final Dio _dio = sl.get<Dio>();
  final String _baseUrl =
      "https://places.googleapis.com/v1/places:searchNearby";

  Future<Either<Object, List<dynamic>>> getNearbyCafes(
    double latitude,
    double longitude,
  ) async {
    try {
      final googleMapsKey = dotenv.env["GOOGLE_MAPS"];
      final response = await _dio.post(
        _baseUrl,
        options: Options(
          contentType: 'application/json',
          headers: {
            "X-Goog-Api-Key": googleMapsKey,
            "X-Goog-FieldMask":
                "places.id,places.displayName,places.formattedAddress,places.location",
          },
        ),
        data: {
          "includedTypes": ["cafe"],
          "maxResultCount": 10,
          "locationRestriction": {
            "circle": {
              "center": {"latitude": latitude, "longitude": longitude},
              "radius": 500.0,
            },
          },
        },
      );

      return (Right(response.data!["places"]));
    } catch (exception) {
      return Left(exception);
    }
  }

  Future<Either<String, List<PointLatLng>?>> getDirection(
    LatLng origin,
    LatLng destination,
  ) async {
    try {
      final googleMapsKey = dotenv.env["GOOGLE_MAPS"];
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'mode': 'walking',
          'key': googleMapsKey,
        },
      );

      if (response.statusCode == 200 && response.data['routes'].isNotEmpty) {
        final encodedPolyline =
            response.data['routes'][0]['overview_polyline']['points'];
        final points = PolylinePoints.decodePolyline(encodedPolyline);
        return Right(points);
      }
      return Right([]);
    } catch (exception) {
      return Left(exception.toString());
    }
  }
}
