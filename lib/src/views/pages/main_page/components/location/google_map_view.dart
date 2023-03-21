import 'dart:async' show StreamSubscription, Completer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:geocoding/geocoding.dart'
    show Placemark, placemarkFromCoordinates, locationFromAddress;
import 'package:geolocator/geolocator.dart' show Position;
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show
        BitmapDescriptor,
        CameraPosition,
        CameraUpdate,
        GoogleMap,
        GoogleMapController,
        LatLng,
        MapType,
        Marker,
        MarkerId;
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomCircularIndicator,
        CustomIcon,
        IconType,
        KText,
        LocalStorage,
        LocationService,
        MyThemeData,
        NavigationBloc,
        PlaceDetails,
        SearchLocationWithAutoComplete,
        TestMainPage,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding,
        kPrimaryBackgroundColor,
        kazakstanCenterPosition,
        logger;
import 'package:papa_burger/src/views/pages/main_page/state/address_result.dart';

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
  final NavigationBloc _navigationBloc = NavigationBloc();
  final LocationService _locationService = LocationService();
  final MapType _mapType = MapType.normal;
  final Set<Marker> _markers = <Marker>{};
  final LocalStorage _localStorage = LocalStorage.instance;
  final CameraPosition _initialCameraPosition =
      const CameraPosition(target: kazakstanCenterPosition, zoom: 13);
  final Completer<GoogleMapController> _controller = Completer();

  late StreamSubscription _markerPositionSub;
  late StreamSubscription _addressResultSubscription;
  BitmapDescriptor _customIcon = BitmapDescriptor.defaultMarker;
  LatLng? _currentPosition;
  Placemark? _placemark;
  String? _currentAddress;
  bool _isLoading = false;
  LatLng _dynamicMarkerPosition = kazakstanCenterPosition;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribeToAddress();
  }

  _subscribeToAddress() {
    _addressResultSubscription =
        _locationService.locationBloc.addressName.listen((result) {
      final isLoading = result is Loading || result is InProggress;
      setState(() {
        _isLoading = isLoading;
      });
      if (isLoading) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  _subscribeToDynamicMarkerPosition() {
    _markerPositionSub =
        _locationService.locationBloc.position.listen((position) {
      setState(() {
        _dynamicMarkerPosition = position;
      });
    });
  }

  _initialPosition() async {
    final cookiePosition = _localStorage.getLocation;

    final customIcon = await _getCustomIcon();
    _customIcon = customIcon;

    _subscribeToDynamicMarkerPosition();

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

  Future<void> _saveLocation(LatLng location, double lat, double lng) async {
    _localStorage.saveLocation(location);
    _localStorage.saveLatLng(location.latitude, location.longitude);
    _localStorage.saveTemporaryLatLngForUpdate(
      location.latitude,
      location.longitude,
    );

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
    _addressResultSubscription.cancel();
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
                  _dynamicMarkerPosition.longitude,
                ).then(
                  (value) => Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                      child: const TestMainPage(),
                      type: PageTransitionType.fade,
                    ),
                    (route) => false,
                  ),
                );
                setState(() {
                  _navigationBloc.navigation(0);
                });
              },
              child: Container(
                height: 40,
                width: double.infinity,
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

  _buildErrorAddress(String error) => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 60,
        ),
        child: const KText(
          text: 'Delivery address isn\'t found',
          size: 26,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      );

  _buildInProggress({bool alsoLoading = false}) {
    const finding = KText(
      text: 'Finding you...',
      size: 26,
      fontWeight: FontWeight.w500,
    );
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 60,
        ),
        child: alsoLoading
            ? Column(
                children: const [
                  finding,
                  SizedBox(height: 6),
                  CustomCircularIndicator(
                    color: Colors.black,
                  ),
                ],
              )
            : finding);
  }

  _buildNoResult() => _buildErrorAddress('');

  _buildOnlyLoading() => const CustomCircularIndicator(color: Colors.black);

  _buildAddressName(BuildContext context, String address) => GestureDetector(
        onTap: () => Navigator.of(context).pushAndRemoveUntil(
          PageTransition(
              child: const SearchLocationWithAutoComplete(),
              type: PageTransitionType.fade),
          (route) => true,
        ),
        child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(
              horizontal: 60,
            ),
            child: Column(children: [
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
              Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultHorizontalPadding, vertical: 2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(kDefaultBorderRadius + 12),
                    ),
                    child: const KText(
                      text: 'Change delivery address',
                      size: 16,
                      maxLines: 1,
                    ),
                  ))
            ])),
      );

  _buildNoInternet() => const KText(
        text: 'No Internet',
        size: 26,
        fontWeight: FontWeight.w500,
        textAlign: TextAlign.center,
      );

  _buildMap(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          mapType: _mapType,
          markers: {
            Marker(
              markerId: const MarkerId('marker'),
              position: _dynamicMarkerPosition,
              icon: _customIcon,
            ),
          },
          initialCameraPosition: _initialCameraPosition,
          myLocationEnabled: true,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          indoorViewEnabled: true,
          padding: const EdgeInsets.fromLTRB(0, 100, 12, 160),
          zoomControlsEnabled: _animationController.isCompleted ? true : false,
          onCameraMoveStarted: () {
            _animationController.reverse();
            _locationService.locationBloc.isFetching.add(true);
          },
          onCameraIdle: () {
            _isLoading ? null : _animationController.forward();
            _locationService.locationBloc.isFetching.add(false);
          },
          onCameraMove: (position) {
            _locationService.locationBloc.findLocation.add(position.target);
            _locationService.locationBloc.onCameraMove.add(position.target);
            _locationService.locationBloc.isFetching.add(true);
            logger.w('position ${position.target}');
          },
        ),
      );

  _buildAddress(BuildContext context) => Positioned(
        top: 100,
        right: 0,
        left: 0,
        child: StreamBuilder<AddressResult>(
          stream: _locationService.locationBloc.addressName,
          builder: (context, snapshot) {
            final addressResult = snapshot.data;
            logger.w('Address Result is $addressResult');
            if (addressResult is AddressError) {
              final error = addressResult.error.toString();
              return _buildErrorAddress(error);
            }
            if (addressResult is InProggress) {
              return _buildInProggress();
            }
            if (addressResult is Loading) {
              return _buildInProggress(alsoLoading: true);
            }
            if (addressResult is OnlyLoading) {
              return _buildOnlyLoading();
            }
            if (addressResult is AddressWithNoResult) {
              return _buildNoResult();
            }
            if (addressResult is AddressNoInternet) {
              return _buildNoInternet();
            }
            if (addressResult is AddressWithResult) {
              final address = addressResult.address;
              return _buildAddressName(context, address);
            }
            return _buildNoResult();
          },
        ),
      );

  _buildNavigateToPlaceDetailsAndPopBtn(BuildContext context) => Positioned(
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
                          setState(() {
                            _navigationBloc.navigation(0);
                          });
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
      );

  _buildUi(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(context),
          _buildAddress(context),
          _buildNavigateToPlaceDetailsAndPopBtn(context),
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
