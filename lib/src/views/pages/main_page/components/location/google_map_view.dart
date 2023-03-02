import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papa_burger/src/restaurant.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  final MapType _mapType = MapType.normal;
  final Set<Marker> _markers = <Marker>{};
  final Prefs storage = Prefs.instance;

  late GoogleMapController _mapController;
  LatLng? _currentPosition;
  Placemark? _placeMark;
  String? currentAdress;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition(context);
  }

  _getCurrentPosition(BuildContext context) async {
    final position = await LocationApi().determineCurrentPosition();
    final addresses =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final placemark = addresses.first;

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _placeMark = placemark;
      currentAdress =
          '${_placeMark!.name} ${_placeMark!.country}, ${_placeMark!.locality}';
      _markers.add(
        Marker(
          markerId: MarkerId(
            _currentPosition.toString(),
          ),
          position: _currentPosition!,
          infoWindow: const InfoWindow(
            title: 'Current possition',
          ),
        ),
      );
    });

    storage.saveLocation(_currentPosition!);
    logger.i(_currentPosition);
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPosition!,
          zoom: 20,
        ),
      ),
    );
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  _addMarker() {}

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  _buildUi(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const CustomCircularIndicator(color: Colors.black)
          : Stack(
              children: [
                SizedBox(
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
                    padding: const EdgeInsets.fromLTRB(12, 100, 12, 160),
                    markers: _markers,
                  ),
                ),
                Positioned(
                  top: 150,
                  right: 0,
                  left: 0,
                  child: _placeMark != null
                      ? GestureDetector(
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
                        )
                      : const CustomCircularIndicator(
                          color: Colors.black,
                        ),
                ),
                _currentPosition != null
                    ? Positioned(
                        left: 20,
                        top: 50,
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
                      )
                    : Container(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getCurrentPosition(context);
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
