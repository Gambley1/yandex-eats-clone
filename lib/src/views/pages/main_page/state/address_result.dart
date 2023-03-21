import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AddressResult {
  const AddressResult();
}

@immutable
class AddressError implements AddressResult {
  final Object error;

  const AddressError(this.error);
}

@immutable
abstract class AddressLoading implements AddressResult {
  const AddressLoading();
}

@immutable
class InProggress implements AddressLoading {
  const InProggress();
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
  final String address;

  const AddressWithResult(this.address);
}

@immutable
class AddressWithNoResult implements AddressResult {
  const AddressWithNoResult();
}

@immutable
class AddressNoInternet implements AddressResult {
  const AddressNoInternet();
}
