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
  final LocalStorage _localStorage = LocalStorage.instance;
  final LatLng _kazakstanCenterPosition = const LatLng(51.1605, 71.4704);
  late final CameraPosition _initialCameraPosition =
      CameraPosition(target: _kazakstanCenterPosition, zoom: 13);

  late GoogleMapController _mapController;
  LatLng? _currentPosition;
  Placemark? _placemark;
  String? _currentAddress;
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
    _initialPosition();
  }

  _initialPosition() async {
    final cookiePosition = _localStorage.getLocation;
    if (cookiePosition == 'No location, please pick one') {
      _addNewMarker(
        _kazakstanCenterPosition,
        name: 'Center of Kazakstan.',
      );
      final placemark = await _getInitialPositionPlacemark();
      _updatePlaceMark(placemark);
    } else {
      final lat = _localStorage.latitude;
      final lng = _localStorage.longitude;
      await Future.delayed(const Duration(milliseconds: 600));
      _navigateToSavedPosition(lat, lng);
    }
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  _navigateToCurrentPosition() async {
    final position = await _getCurrentPosition();
    _addNewMarker(_currentPosition!);
    _animateCamera(_currentPosition!);
    final placemark = await _getPlacemark(position);
    _updatePlaceMark(placemark);
    setState(() {});
  }

  _navigateToSavedPosition(double lat, double lng) async {
    final cookiePosition = LatLng(lat, lng);
    _addNewMarker(cookiePosition);
    _animateCamera(cookiePosition);
    final position = await _getCurrentPosition();
    setState(() {});
    final placemark = await _getPlacemark(position);
    _updatePlaceMark(placemark);
  }

  _navigateToPlaceDetails() async {
    final lat = widget.placeDetails?.geometry.location.lat;
    final lng = widget.placeDetails?.geometry.location.lng;

    final formattedAddress = widget.placeDetails?.formattedAddress;

    if (lat == null && lng == null) return;

    final placemark = await _getPlacemarkFromAddress(formattedAddress!);

    _updatePlaceMark(placemark);

    final newPosition = LatLng(lat!, lng!);
    _currentPosition = newPosition;

    _animateCamera(newPosition);
    _addNewMarker(newPosition, name: widget.placeDetails!.name);

    setState(() {});
  }

  Future<Position> _getCurrentPosition() async {
    final position =
        await _locationService.locationApi.determineCurrentPosition();
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

  Future<Placemark> _getInitialPositionPlacemark() async {
    final lat = _kazakstanCenterPosition.latitude;
    final lng = _kazakstanCenterPosition.longitude;

    final addresss = await placemarkFromCoordinates(lat, lng);
    final placemark = addresss.first;

    return placemark;
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

    _currentAddress =
        '${_placemark!.name} ${_placemark!.country}, ${_placemark!.locality}';
  }

  _saveLocation(LatLng location, [String? address]) {
    _localStorage.saveLocation(location);
    _localStorage.saveLatLng(location.latitude, location.longitude);

    address == null ? null : _localStorage.saveAddressName(address);

    logger.w('SAVING LOCATION $location AND ADDRESS $address');
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  _buildSaveLocationBtn(
      BuildContext context, LatLng? location, String? address) {
    final hasPosition = location != null && address != null;
    final position = LatLng(_localStorage.latitude, _localStorage.longitude);
    final sameLocations = location == position;
    return Positioned(
      bottom: 75,
      left: 40,
      right: 80,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: InkWell(
              onTap: () {
                hasPosition
                    ? sameLocations
                        ? widget.placeDetails == null
                            ? Navigator.of(context).pushAndRemoveUntil(
                                PageTransition(
                                    child:
                                        const SearchLocationWithAutoComplete(),
                                    type: PageTransitionType.fade),
                                (route) => true)
                            : _navigateToPlaceDetails()
                        : _saveLocation(location, address)
                    : _navigateToCurrentPosition();
              },
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                  color: kPrimaryBackgroundColor,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5.0,
                      color: Colors.black54,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: KText(
                  text: hasPosition
                      ? sameLocations
                          ? 'Pick new position?'
                          : 'Save'
                      : 'Go to current address.',
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _buildUi(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              mapType: _mapType,
              initialCameraPosition: _initialCameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              indoorViewEnabled: true,
              trafficEnabled: true,
              padding: const EdgeInsets.fromLTRB(0, 100, 12, 160),
              markers: _markers,
              zoomControlsEnabled:
                  _animationController.isCompleted ? true : false,
              onCameraMoveStarted: () {
                _isMovingMarker == false
                    ? _animationController.reverse()
                    : null;
                _isMovingMarker = true;
                logger.i(_isMovingMarker);
              },
              onCameraIdle: () async {
                await Future.delayed(const Duration(milliseconds: 200));
                _isMovingMarker = false;
                _isMovingMarker == false
                    ? _animationController.forward()
                    : null;
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
                                  text: _currentAddress!,
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
                  child: Row(
                    children: [
                      Material(
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
                      const SizedBox(
                        width: 12,
                      ),
                      widget.placeDetails == null
                          ? Container()
                          : Material(
                              elevation: 3,
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: CustomIcon(
                                  icon: FontAwesomeIcons.paperPlane,
                                  type: IconType.iconButton,
                                  onPressed: () {
                                    _navigateToPlaceDetails();
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildSaveLocationBtn(context, _currentPosition, _currentAddress),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: FloatingActionButton(
              onPressed: () {
                _navigateToCurrentPosition();
              },
              elevation: 3,
              backgroundColor: Colors.white,
              child: const CustomIcon(
                icon: FontAwesomeIcons.circleDot,
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
