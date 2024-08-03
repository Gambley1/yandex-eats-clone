// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'location_bloc.dart';

enum LocationStatus {
  initial,
  loading,
  populated,
  failure;

  bool get isLoading => this == LocationStatus.loading;
}

class LocationState extends Equatable {
  const LocationState._({
    required this.status,
    required this.location,
    required this.address,
  });

  const LocationState.initial()
      : this._(
          status: LocationStatus.initial,
          location: const Location.undefined(),
          address: const Address(),
        );

  final LocationStatus status;
  final Location location;
  final Address address;

  @override
  List<Object?> get props => [status, location, address];

  LocationState copyWith({
    LocationStatus? status,
    Location? location,
    Address? address,
  }) {
    return LocationState._(
      status: status ?? this.status,
      location: location ?? this.location,
      address: address ?? this.address,
    );
  }
}
