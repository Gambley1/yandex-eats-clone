import 'dart:async' show StreamSubscription, Completer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:geocoding/geocoding.dart'
    show Placemark, placemarkFromCoordinates, locationFromAddress;
import 'package:geolocator/geolocator.dart' show Position;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;
import 'package:papa_burger/src/restaurant.dart'
    show
        PlaceDetails,
        LocationService,
        LocalStorage,
        kazakstanCenterPosition,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding,
        kPrimaryBackgroundColor,
        logger,
        KText,
        CustomCircularIndicator,
        CustomIcon,
        SearchLocationWithAutoComplete,
        IconType,
        MyThemeData;

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
  final CameraPosition _initialCameraPosition =
      const CameraPosition(target: kazakstanCenterPosition, zoom: 13);
  final Completer<GoogleMapController> _controller = Completer();

  late BitmapDescriptor _customIcon;
  late StreamSubscription _markerPositionSub;
  LatLng? _currentPosition;
  Placemark? _placemark;
  String? _currentAddress;
  late LatLng _dynamicMarkerPosition;

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150))
      ..addListener(() {
        setState(() {});
      });
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _animationController.forward();
    _initialPosition();
  }

  _initialPosition() async {
    final cookiePosition = _localStorage.getLocation;

    final customIcon = await _getCustomIcon();
    _customIcon = customIcon;

    _markerPositionSub =
        _locationService.locationBloc.position.listen((newPosition) {
      _dynamicMarkerPosition = newPosition;
    });

    if (cookiePosition == 'No location, please pick one') {
      _addNewMarker(
        kazakstanCenterPosition,
        name: 'Center of Kazakstan.',
      );
      final placemark = await _getInitialPositionPlacemark();
      _updatePlaceMark(placemark);
      logger.w('NAVIGATING TO ASTANA');
    } else {
      final lat = _localStorage.latitude;
      final lng = _localStorage.longitude;
      if (lat == 0 && lng == 0) {
        return;
      }
      _navigateToSavedPosition(lat, lng);
      logger.w('NAVIGATING TO SAVED POSITION');
    }
  }

  _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
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

    await Future.delayed(const Duration(milliseconds: 600));

    _animateCamera(cookiePosition);
    final position = await _getLastKnownAddress();

    final placemark = await _getPlacemark(position);
    _updatePlaceMark(placemark);
    setState(() {});
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

  _animateCamera(LatLng newPosition, {double zoom = 18}) async {
    _controller.future.then(
      (gMap) => gMap.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newPosition,
            zoom: zoom,
          ),
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

  _updatePlaceMark(Placemark placemark) {
    _placemark = placemark;

    _currentAddress =
        '${_placemark!.name} ${_placemark!.country}, ${_placemark!.locality}';
  }

  _saveLocation(LatLng location, double lat, double lng) async {
    _localStorage.saveLocation(location);
    _localStorage.saveLatLng(location.latitude, location.longitude);

    final addressName = await _getCurrentAddressName(lat, lng);
    _localStorage.saveAddressName(addressName);

    logger.w('SAVING LOCATION $location AND ADDRESS $addressName');
  }

  Future<BitmapDescriptor> _getCustomIcon() async {
    final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(2, 2)),
      'assets/icons/pin.png',
    );
    return customIcon;
  }

  Future<Position> _getCurrentPosition() async {
    final position =
        await _locationService.locationApi.determineCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);
    return position;
  }

  Future<Position> _getLastKnownAddress() async {
    final lastKnownPosition =
        await _locationService.locationApi.getLastKnownPosition();
    return lastKnownPosition;
  }

  Future<Placemark> _getInitialPositionPlacemark() async {
    final lat = kazakstanCenterPosition.latitude;
    final lng = kazakstanCenterPosition.longitude;

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

  Future<String> _getCurrentAddressName(double lat, double lng) async {
    final address =
        await _locationService.locationApi.getFormattedAddress(lat, lng);
    return address;
  }

  @override
  void dispose() {
    _controller.future.then((gMap) => gMap.dispose());
    _locationService.locationBloc.dispose();
    _markerPositionSub.cancel();
    super.dispose();
  }

  _buildSaveLocationBtn(BuildContext context) {
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
                _saveLocation(
                    _dynamicMarkerPosition,
                    _dynamicMarkerPosition.latitude,
                    _dynamicMarkerPosition.longitude);
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
                child: const KText(
                  text: 'Save',
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
            child: StreamBuilder<LatLng>(
                stream: _locationService.locationBloc.position,
                builder: (context, snapshot) {
                  final dynamicMarkerPosition =
                      snapshot.data ?? _dynamicMarkerPosition;
                  return GoogleMap(
                    onMapCreated: _onMapCreated,
                    mapType: _mapType,
                    markers: {
                      Marker(
                        markerId: const MarkerId('marker'),
                        position: dynamicMarkerPosition,
                        icon: _customIcon,
                      ),
                    },
                    initialCameraPosition: _initialCameraPosition,
                    myLocationEnabled: true,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    indoorViewEnabled: true,
                    padding: const EdgeInsets.fromLTRB(0, 100, 12, 160),
                    zoomControlsEnabled:
                        _animationController.isCompleted ? true : false,
                    onCameraMoveStarted: () {
                      _animationController.reverse();

                      logger.i('CAMERA STARTED');
                    },
                    onCameraIdle: () {
                      _animationController.forward();

                      logger.i('CAMERA IDLE');
                    },
                    onCameraMove: (position) {
                      _locationService.locationBloc.findLocation
                          .add(position.target);
                      _locationService.locationBloc.onCameraMove
                          .add(position.target);

                      logger.i('CAMERA MOVES');
                    },
                  );
                }),
          ),
          Positioned(
              top: 100,
              right: 0,
              left: 0,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: StreamBuilder<String>(
                      stream: _locationService.locationBloc.addressName,
                      builder: (context, snapshot) {
                        final address = snapshot.data;
                        // final loading =
                        //     snapshot.connectionState == ConnectionState.waiting;
                        return address == null
                            ? const CustomCircularIndicator(color: Colors.black)
                            : _animationController.isCompleted
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          PageTransition(
                                            child:
                                                const SearchLocationWithAutoComplete(),
                                            type: PageTransitionType.fade,
                                          ),
                                          (route) => true);
                                    },
                                    child: Container(
                                      // padding: const EdgeInsets.symmetric(
                                      //   horizontal: 60,
                                      // ),
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 60,
                                      ),
                                      child: Column(
                                        children: [
                                          KText(
                                            text: address,
                                            maxLines: 3,
                                            size: 30,
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          const SizedBox(
                                            height: 28,
                                          ),
                                          Container(
                                            width: 220,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    kDefaultHorizontalPadding,
                                                vertical: 2),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kDefaultBorderRadius +
                                                          12),
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
                                  )
                                : const SizedBox.shrink();
                      },
                    ),
                  );
                },
              )),
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
          _buildSaveLocationBtn(context),
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
