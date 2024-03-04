import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show CameraPosition, GoogleMap, LatLng;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/views/pages/main/services/location_service.dart';
import 'package:papa_burger/src/views/pages/main/state/address_result.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({
    super.key,
    this.placeDetails,
    this.fromLogin = false,
  });

  final PlaceDetails? placeDetails;
  final bool fromLogin;

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView>
    with TickerProviderStateMixin {
  final LocationService _locationService = LocationService();

  late StreamSubscription<dynamic> _addressResultSubscription;
  late StreamSubscription<dynamic> _isMovingSubscription;
  bool _isLoading = false;
  bool _isMoving = false;

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );

    _animationController.forward();
    _locationService.locationHelper.initMapConfiguration;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribeToAddress();
    _subscribeToMoving();
  }

  void _subscribeToAddress() {
    _addressResultSubscription =
        _locationService.locationBloc.addressName.listen((result) {
      final isLoading = result is Loading || result is InProggress;
      if (mounted) {
        setState(() {
          _isLoading = isLoading;
        });
      }
      if (isLoading) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  void _subscribeToMoving() {
    _isMovingSubscription =
        _locationService.locationBloc.moving.listen((isMoving) {
      _isMoving = isMoving;
    });
  }

  @override
  void dispose() {
    _locationService.locationHelper.dispose();
    _locationService.locationBloc.dispose();
    _isMovingSubscription.cancel();
    _addressResultSubscription.cancel();
    super.dispose();
  }

  Positioned _buildSaveLocationBtn(BuildContext context) {
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
                _locationService.locationHelper
                    .saveLocation(
                      _locationService.locationHelper.dynamicMarkerPosition,
                    )
                    .then(
                      (value) => widget.fromLogin
                          ? context.navigateToMainPage()
                          : context.pop(),
                    );
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
                      blurRadius: 5,
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
            ).ignorePointer(isMoving: _isMoving),
          );
        },
      ),
    );
  }

  Widget _buildErrorAddress(String error) => GestureDetector(
        onTap: () => context.navigateToSearchLocationWithAutoComplete(),
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(
            horizontal: 60,
          ),
          child: const KText(
            text: "Delivery address isn't found",
            size: 26,
            textAlign: TextAlign.center,
          ),
        ),
      );

  Widget _buildInProggress({bool alsoLoading = false}) {
    const finding = KText(
      text: 'Finding you...',
      size: 26,
    );
    return GestureDetector(
      onTap: () => context.navigateToSearchLocationWithAutoComplete(),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 60,
        ),
        child: alsoLoading
            ? const Column(
                children: [
                  finding,
                  SizedBox(height: 6),
                  CustomCircularIndicator(
                    color: Colors.black,
                  ),
                ],
              )
            : finding,
      ),
    );
  }

  Widget _buildNoResult() => _buildErrorAddress('');

  Widget _buildAddressName(BuildContext context, String address) =>
      GestureDetector(
        onTap: () => context.navigateToSearchLocationWithAutoComplete(),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return Container(
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
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: 220,
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultHorizontalPadding,
                        vertical: 2,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(kDefaultBorderRadius + 12),
                      ),
                      child: const KText(
                        text: 'Change delivery address',
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

  Widget _buildNoInternet() => const KText(
        text: 'No Internet',
        size: 26,
        textAlign: TextAlign.center,
      ).ignorePointer(isMoving: _isMoving);

  Widget _buildMap(BuildContext context) {
    return SizedBox(
      height: context.screenHeight,
      width: context.screenWidth,
      child: StreamBuilder<LatLng>(
        stream: _locationService.locationHelper.dynamicMarkerPositionStream,
        builder: (context, snapshot) {
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: _locationService.locationHelper.onMapCreated,
                mapType: _locationService.locationHelper.mapType,
                initialCameraPosition:
                    _locationService.locationHelper.initialCameraPosition,
                myLocationEnabled: true,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                indoorViewEnabled: true,
                padding: const EdgeInsets.fromLTRB(0, 100, 12, 160),
                zoomControlsEnabled: _animationController.isCompleted,
                onCameraMoveStarted: () {
                  if (mounted) {
                    _locationService.locationHelper
                        .onCameraStarted(_animationController);
                  }
                },
                onCameraIdle: () {
                  if (mounted) {
                    _locationService.locationHelper.onCameraIdle(
                      isLoading: _isLoading,
                      _animationController,
                    );
                  }
                },
                onCameraMove: (CameraPosition position) {
                  if (mounted) {
                    _locationService.locationHelper.onCameraMove(position);
                  }
                },
              ),
              Center(
                child: Container(
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.only(bottom: 100, right: 10),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/icons/pin.png',
                      ),
                    ),
                  ),
                ),
              ).ignorePointer(isMoving: true),
            ],
          );
        },
      ),
    );
  }

  Positioned _buildAddress(BuildContext context) => Positioned(
        top: 100,
        right: 0,
        left: 0,
        child: StreamBuilder<AddressResult>(
          stream: _locationService.locationBloc.addressName,
          builder: (context, snapshot) {
            final addressResult = snapshot.data;
            if (addressResult is AddressError) {
              final error = addressResult.error.toString();
              return _buildErrorAddress(error)
                  .ignorePointer(isMoving: _isMoving);
            }
            if (addressResult is InProggress) {
              return _buildInProggress();
            }
            if (addressResult is Loading) {
              return _buildInProggress(alsoLoading: true);
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

  Positioned _buildNavigateToPlaceDetailsAndPopBtn(BuildContext context) =>
      Positioned(
        left: 20,
        top: 50,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
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
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  if (widget.placeDetails == null)
                    Container()
                  else
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
                          icon: FontAwesomeIcons.paperPlane,
                          type: IconType.iconButton,
                          onPressed: () {
                            _locationService.locationHelper
                                .navigateToPlaceDetails(
                              widget.placeDetails,
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ).ignorePointer(isMoving: _isMoving),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayTheme.googleMapView,
      child: AppScaffold(
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
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: _opacityAnimation.value,
              child: FloatingActionButton(
                onPressed: () =>
                    _locationService.locationHelper.navigateToCurrentPosition,
                elevation: 3,
                backgroundColor: Colors.white,
                child: const CustomIcon(
                  icon: FontAwesomeIcons.circleDot,
                  type: IconType.simpleIcon,
                  size: 20,
                ),
              ).ignorePointer(isMoving: _isMoving),
            );
          },
        ),
      ),
    );
  }
}
