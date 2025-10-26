// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brewmap/features/maps/models/cafe_model.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MapsStatus {
  initial,
  loading,
  permissionDeniedForever,
  permissionAllowed,
  permissionDenied,
  locationLoaded,
  cafesLoaded,
  failure,
}

class MapsState extends Equatable {
  final MapsStatus? status;
  final Position? position;
  final List<CafeModel>? cafes;
  final Set<Marker>? markers;
  final Set<Polyline>? polylines;
  final GoogleMapController? controller;
  final String? error;

  const MapsState({
    this.status,
    this.position,
    this.cafes,
    this.markers,
    this.polylines,
    this.controller,
    this.error,
  });

  factory MapsState.initial() {
    return MapsState(
      status: MapsStatus.initial,
      cafes: [],
      markers: {},
      polylines: {},
    );
  }

  MapsState copyWith({
    MapsStatus? status,
    Position? position,
    List<CafeModel>? cafes,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    GoogleMapController? controller,
    String? error,
  }) {
    return MapsState(
      status: status ?? this.status,
      position: position ?? this.position,
      cafes: cafes ?? this.cafes,
      markers: markers ?? this.markers,
      controller: controller ?? this.controller,
      polylines: polylines ?? this.polylines,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    position,
    cafes,
    markers,
    controller,
    polylines,
    status,
    error,
  ];
}
