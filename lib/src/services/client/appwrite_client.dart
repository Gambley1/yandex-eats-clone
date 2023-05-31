import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';

import 'package:papa_burger/src/data/logger.dart';

class AppwriteClient extends ValueNotifier<Client> {
  factory AppwriteClient() => _instance;

  AppwriteClient._privateConstructor()
      : super(
          Client()
              .setEndpoint('http://localhost/v1')
              .setProject('64745c982f3fc86896a7')
              .setSelfSigned(),
        ) {
    logger.i('Init AppwriteClient');
  }

  static final _instance = AppwriteClient._privateConstructor();

  Client get _client => value;

  Databases get db => Databases(_client);

  Account get account => Account(_client);

  Functions get function => Functions(_client);

  Graphql get graphql => Graphql(_client);

  Locale get locale => Locale(_client);

  Storage get storage => Storage(_client);

  Teams get teams => Teams(_client);
}
