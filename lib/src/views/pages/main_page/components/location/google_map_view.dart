import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papa_burger/src/models/auto_complete/place_details.dart';
import 'package:papa_burger/src/restaurant.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({
    super.key,
    this.placeDetails,
  });

  final PlaceDetails? placeDetails;

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView>
    with TickerProviderStateMixin {
  final LocationService _locationService = LocationService();
  final MapType _mapType = MapType.normal;
  final Set<Marker> _markers = <Marker>{};
  final Prefs storage = Prefs.instance;

  late GoogleMapController _mapController;
  LatLng? _currentPosition;
  Placemark? _placemark;
  String? currentAdress;
  bool _isMovingMarker = false;

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150))
      ..addListener(() {
        setState(() {
          logger.i(_isMovingMarker);
        });
      });
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _animationController.forward();
    _initPosition();
  }

  _initPosition() async {
    await _getCurrentPosition();
    setState(() {});
    _addNewMarker(_currentPosition!, name: 'Current position');

    storage.saveLocation(_currentPosition!);
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  _navigateToCurrentPosition(BuildContext context) async {
    _getCurrentPosition();
    _animateCamera(_currentPosition!);
  }

  _navigateToPlaceDetails() async {
    final lat = widget.placeDetails?.geometry.location.lat;
    final lng = widget.placeDetails?.geometry.location.lng;
    final formattedAddress = widget.placeDetails?.formattedAddress;
    if (lat == null && lng == null) return;
    final placemark = await _getPlacemarkFromAddress(formattedAddress!);
    _updatePlaceMark(placemark);
    final newPosition = LatLng(lat!, lng!);
    _animateCamera(newPosition);
    _addNewMarker(newPosition, name: widget.placeDetails!.name);
    storage.saveLocation(newPosition);
    setState(() {});
  }

  Future<Position> _getCurrentPosition() async {
    final position =
        await _locationService.locationApi.determineCurrentPosition();
    final placemark = await _getPlacemark(position);
    _updatePlaceMark(placemark);
    setState(() {});
    _currentPosition = LatLng(position.latitude, position.longitude);
    return position;
  }

  _animateCamera(LatLng newPosition, {double zoom = 18}) {
    setState(() {});
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: newPosition,
          zoom: zoom,
        ),
      ),
    );
  }

  _addNewMarker(LatLng position, {String name = 'New position'}) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: MarkerId(name),
        position: position,
      ),
    );
  }

  Future<Placemark> _getPlacemark(Position position) async {
    final addresses =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final placemark = addresses.first;
    return placemark;
  }

  Future<Placemark> _getPlacemarkFromAddress(String formattedAddress) async {
    final positions = await locationFromAddress(formattedAddress);
    final location = positions.first;
    final placemark =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    return placemark.first;
  }

  _updatePlaceMark(Placemark placemark) {
    setState(() {});
    _placemark = placemark;
    currentAdress =
        '${_placemark!.name} ${_placemark!.country}, ${_placemark!.locality}';
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  _buildUi(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentPosition == null
              ? const CustomCircularIndicator(color: Colors.black)
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    mapType: _mapType,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    indoorViewEnabled: true,
                    trafficEnabled: true,
                    padding: const EdgeInsets.fromLTRB(0, 100, 12, 160),
                    markers: _markers,
                    zoomControlsEnabled:
                        _animationController.isCompleted ? true : false,
                    onCameraMoveStarted: () {
                      _isMovingMarker == false ? _animationController.reverse() : null;
                      _isMovingMarker = true;
                      logger.i(_isMovingMarker);
                    },
                    onCameraIdle: () async {
                      await Future.delayed(const Duration(milliseconds: 200));
                      _isMovingMarker = false;
                      _isMovingMarker == false ? _animationController.forward() : null;
                      logger.i(_isMovingMarker);
                    },
                    onCameraMove: (position) {
                      _isMovingMarker = true;
                      logger.i(_isMovingMarker);
                    },
                  ),
                ),
          Positioned(
            top: 100,
            right: 0,
            left: 0,
            child: _placemark != null
                ? AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                PageTransition(
                                  child: const SearchLocationWithAutoComplete(),
                                  type: PageTransitionType.fade,
                                ),
                                (route) => true);
                          },
                          child: Container(
                            width: 300,
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                KText(
                                  text: currentAdress!,
                                  maxLines: 3,
                                  size: 30,
                                  fontWeight: FontWeight.w600,
                                ),
                                const SizedBox(
                                  height: 42,
                                ),
                                Container(
                                  width: 220,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kDefaultHorizontalPadding,
                                      vertical: 2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        kDefaultBorderRadius + 12),
                                  ),
                                  child: const KText(
                                    text: 'Change delivery address',
                                    size: 16,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Container(),
          ),
          Positioned(
            left: 20,
            top: 50,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIcon(
                        icon: FontAwesomeIcons.arrowLeft,
                        type: IconType.iconButton,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: _currentPosition == null
          ? Container()
          : AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: FloatingActionButton(
                    onPressed: () {
                      _navigateToPlaceDetails();
                    },
                    elevation: 3,
                    backgroundColor: Colors.white,
                    child: const CustomIcon(
                      icon: FontAwesomeIcons.paperPlane,
                      type: IconType.simpleIcon,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.googleMapView,
      child: Builder(
        builder: (context) {
          return _buildUi(context);
        },
      ),
    );
  }
}
