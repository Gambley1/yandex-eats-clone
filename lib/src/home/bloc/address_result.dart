import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AddressResult {
  const AddressResult();
}

@immutable
class AddressError implements AddressResult {
  const AddressError(this.error);
  final Object error;
}

@immutable
abstract class AddressLoading implements AddressResult {
  const AddressLoading();
}

@immutable
class InProgress implements AddressLoading {
  const InProgress();
}

@immutable
class Loading implements AddressLoading {
  const Loading();
}

@immutable
class OnlyLoading implements AddressLoading {
  const OnlyLoading();
}

@immutable
class AddressWithResult implements AddressResult {
  const AddressWithResult(this.address);
  final String address;
}

@immutable
class AddressWithNoResult implements AddressResult {
  const AddressWithNoResult();
}

@immutable
class AddressNoInternet implements AddressResult {
  const AddressNoInternet();
}
