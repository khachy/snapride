import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:snapride/utils/helpers/app_helpers.dart';
import 'package:snapride/utils/themes/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  final Set<Marker> _markers = {};
  Offset? markerScreenPosition;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  /// Fetches the user's current location.
  Future<void> _fetchUserLocation() async {
    try {
      // Request the current position with high accuracy.
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _currentLocation!,
            // icon: customIcon,
            visible: false,
          ),
        );
      });

      // Update the screen position of the marker once the map is available.
      if (_mapController != null) _updateMarkerScreenPosition();
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  /// Converts the current location to screen coordinates and updates state.
  Future<void> _updateMarkerScreenPosition() async {
    if (_mapController != null && _currentLocation != null) {
      ScreenCoordinate screenCoordinate =
          await _mapController!.getScreenCoordinate(_currentLocation!);
      final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      setState(() {
        markerScreenPosition = Offset(
          screenCoordinate.x / pixelRatio,
          screenCoordinate.y / pixelRatio,
        );
      });
    }
  }

  @override
  void dispose() {
    // _rippleController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Google Map widget.
    Widget mapWidget = GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentLocation ?? const LatLng(0, 0),
        zoom: 16.0,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        _updateMarkerScreenPosition();
      },
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onCameraMove: (position) {
        // Calculate the distance between the camera's current target and the user's current location.
        if (_currentLocation != null) {
          double distance = Geolocator.distanceBetween(
            _currentLocation!.latitude,
            _currentLocation!.longitude,
            position.target.latitude,
            position.target.longitude,
          );
          // If distance is more than 50 meters, show the button; otherwise hide it.
          bool visible = distance > 50;
          if (visible != isVisible) {
            setState(() {
              isVisible = visible;
            });
          }
        }
        _updateMarkerScreenPosition();
      },
    );

    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: (_currentLocation == null)
          ? Center(
              child: const CircularProgressIndicator(),
            )
          : Stack(
              children: [
                mapWidget,
                DraggableScrollableSheet(
                  initialChildSize:
                      0.22, // Initial size as a fraction of screen height.
                  minChildSize: 0.1, // Minimum size when collapsed.
                  maxChildSize: 0.5, // Maximum size when expanded.
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.kWhiteColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AppHelpers.bottomSheetIndicator(),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          AppHelpers.containerInSheet(
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.search_normal,
                                  size: 18,
                                  color: AppColors.kBlackColor,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  'Going anywhere?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.kBlackColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AppHelpers.containerInSheet(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.share,
                                        size: 18,
                                        color: AppColors.kBlackColor,
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Snapshare',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.kBlackColor,
                                            ),
                                          ),
                                          Text(
                                            'Share a ride?',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.kGreyColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              Expanded(
                                child: AppHelpers.containerInSheet(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.calendar_add,
                                        size: 18,
                                        color: AppColors.kBlackColor,
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Snapdraft',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.kBlackColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 90.w,
                                            child: Text(
                                              'Schedule a ride?',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.kGreyColor,
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 16,
                  // Adjust the bottom offset to appear above the sheet.
                  bottom: 16 + MediaQuery.of(context).size.height * 0.25,
                  child: isVisible
                      ? FloatingActionButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          backgroundColor: AppColors.kWhiteColor,
                          onPressed: () {
                            if (_currentLocation != null &&
                                _mapController != null) {
                              _mapController!.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: _currentLocation!,
                                    zoom: 16.0,
                                  ),
                                ),
                              );
                            }
                          },
                          // elevation: 0,
                          child: Icon(
                            Icons.my_location_rounded,
                            size: 24,
                            color: AppColors.kBlackColor,
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
    );
  }
}
