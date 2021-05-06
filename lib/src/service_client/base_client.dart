/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: base_client.dart
 * Project: animaltracing_unofficial_binding.
 */

import '../soap/soap_request.dart';
import '../soap/soap_response.dart';
import 'creation_stub.dart'
    if (dart.library.html) 'browser_client.dart'
    if (dart.library.io) 'io_client.dart';

abstract class BaseClient {
  final Duration? timeOutDuration;

  BaseClient(this.timeOutDuration);

  Future<SoapResponse> sendRequest(
      SoapRequest soapRequest, String authorizationToken);

  factory BaseClient.create(Duration? timeOutDuration) {
    return createClient(timeOutDuration);
  }
}
