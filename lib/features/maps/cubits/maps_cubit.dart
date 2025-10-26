import 'package:bloc/bloc.dart';
import 'package:brewmap/dependency_injection.dart';
import 'package:brewmap/features/maps/cubits/maps_state.dart';
import 'package:brewmap/features/maps/data/repositories/maps_repository.dart';
import 'package:brewmap/features/maps/models/cafe_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsCubit extends Cubit<MapsState> {
  final MapsRepository _mapsRepository = sl.get<MapsRepository>();

  MapsCubit() : super(MapsState.initial());

  void resetMap() {
    emit(MapsState.initial());
  }

  void setMapController(GoogleMapController controller) {
    emit(state.copyWith(controller: controller));
  }

  Future checkLocationPermission() async {
    emit(state.copyWith(status: MapsStatus.loading));
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      emit(state.copyWith(status: MapsStatus.permissionDeniedForever));
    }

    if (permission != LocationPermission.always ||
        permission != LocationPermission.whileInUse) {
      final requestPermission = await Geolocator.requestPermission();

      if (requestPermission == LocationPermission.always ||
          requestPermission == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition();
        emit(
          state.copyWith(status: MapsStatus.permissionAllowed, position: pos),
        );
      } else {
        emit(state.copyWith(status: MapsStatus.permissionDenied));
      }
    }
  }

  Future openSettings() async {
    await Geolocator.openAppSettings();
  }

  Future getUserLocation() async {
    final position = await Geolocator.getCurrentPosition();
    emit(state.copyWith(position: position, status: MapsStatus.locationLoaded));
  }

  Future getNearbyCafes() async {
    final response = await _mapsRepository.getNearbyCafes(
      state.position!.latitude,
      state.position!.longitude,
    );

    response.fold(
      (String errorMessage) {
        emit(state.copyWith(error: errorMessage, status: MapsStatus.failure));
      },
      (List<CafeModel> list) {
        emit(state.copyWith(cafes: list, status: MapsStatus.cafesLoaded));
      },
    );
  }

  Future getDirection(CafeModel cafe) async {
    final response = await _mapsRepository.getDirection(
      state.position!.latitude,
      state.position!.longitude,
      LatLng(cafe.latitude, cafe.longitude),
    );

    response.fold(
      (String errorMessage) {
        emit(state.copyWith(error: errorMessage, status: MapsStatus.failure));
      },
      (List<LatLng> points) {
        final Set<Polyline> polyline = {
          Polyline(
            polylineId: PolylineId(cafe.id),
            points: points,
            color: Colors.blue,
            width: 5,
            patterns: [PatternItem.dash(25)],
          ),
        };

        emit(
          state.copyWith(
            polylines: polyline,
            markers: {
              Marker(
                markerId: MarkerId(cafe.id),
                position: LatLng(cafe.latitude, cafe.longitude),
              ),
            },
          ),
        );
      },
    );
  }
}
