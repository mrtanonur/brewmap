import 'package:brewmap/core/utils/constants/constants.dart';
import 'package:brewmap/core/widgets/brewmap_cafe_tile.dart';
import 'package:brewmap/features/maps/cubits/maps_cubit.dart';
import 'package:brewmap/features/maps/cubits/maps_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MapsCubit>().checkLocationPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapsCubit, MapsState>(
      listener: (context, state) async {
        if (state.status == MapsStatus.locationLoaded) {
          // future delayed to delay zooming once app is open
          Future.delayed(Durations.long4, () async {
            if (mounted) {
              await context.read<MapsCubit>().state.controller!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                      state.position!.latitude,
                      state.position!.longitude,
                    ),
                    zoom: 16,
                  ),
                ),
              );
            }
          });
        }

        if (state.status == MapsStatus.permissionAllowed) {
          context.read<MapsCubit>().getUserLocation();
        }
      },

      builder: (context, state) {
        if (state.position == null) {
          return const Center(child: CircularProgressIndicator());
        }
        Set<Marker> markers = {};
        if (state.status == MapsStatus.cafesLoaded) {
          markers = state.cafes!
              .map(
                (restaurant) => Marker(
                  markerId: MarkerId(restaurant.name),
                  position: LatLng(restaurant.latitude, restaurant.longitude),
                  onTap: () {},
                ),
              )
              .toSet();
        }

        if (state.status == MapsStatus.permissionDeniedForever) {
          return PermisionDeniedPage();
        } else {
          return Scaffold(
            floatingActionButton: state.status != MapsStatus.cafesLoaded
                ? Padding(
                    padding: const EdgeInsets.only(
                      bottom: SizeConstants.s20,
                      right: SizeConstants.s20,
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        context.read<MapsCubit>().getNearbyCafes();
                      },
                      child: Icon(Icons.coffee),
                    ),
                  )
                : null,

            body: Stack(
              alignment: AlignmentGeometry.bottomCenter,
              children: [
                map(state, markers),
                // * In cases where we need to contionally render more than one widgets or pages in -
                // * -  a widgets list we need to use ...[] and add our widgets inside bracket
                if (state.status == MapsStatus.loading) ...[
                  Center(child: CircularProgressIndicator()),
                ],

                if (state.status == MapsStatus.cafesLoaded) CafesCard(),
              ],
            ),
          );
        }
        // switch (state.status) {

        //   case MapsStatus.locationLoaded:
        //   case MapsStatus.permissionDeniedForever:
        //   case MapsStatus.cafesLoaded:
        //   case MapsStatus.failure:
        //   default:
        // }
      },
    );
  }

  Widget map(MapsState state, Set<Marker> markers) {
    return GoogleMap(
      scrollGesturesEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      markers: markers,
      polylines: state.polylines!,
      onMapCreated: (controller) {
        context.read<MapsCubit>().setMapController(controller);
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      rotateGesturesEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(state.position!.latitude, state.position!.longitude),

        // initialCameraPosition: CameraPosition(target: LatLng(41.0472, 29.0269)),
      ),
    );
  }
}

class CafesCard extends StatelessWidget {
  const CafesCard({super.key});

  @override
  Widget build(BuildContext context) {
    MapsStatus status = context.read<MapsCubit>().state.status!;
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: status == MapsStatus.cafesLoaded ? 0.4 : 0.9,
      expand: false,

      builder: (context, scrollController) {
        return Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(SizeConstants.s20),
                    topRight: Radius.circular(SizeConstants.s20),
                  ),
                ),
                padding: const EdgeInsets.all(SizeConstants.s8),
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: context.read<MapsCubit>().state.cafes!.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: SizeConstants.s12);
                  },
                  itemBuilder: (context, index) {
                    return BrewmapCafeTile(
                      onTap: () {
                        context.read<MapsCubit>().getDirection(
                          context.read<MapsCubit>().state.cafes![index],
                        );
                      },
                      cafe: context.read<MapsCubit>().state.cafes![index],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PermisionDeniedPage extends StatelessWidget {
  const PermisionDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "In order to use the application you need to give location permission access to the app in the settings",
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MapsCubit>().openSettings();
            },
            child: Text("Give Location Acceess"),
          ),
        ],
      ),
    );
  }
}
