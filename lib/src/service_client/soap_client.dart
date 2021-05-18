/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: soap_client.dart
 * Project: animaltracing_unofficial_binding.
 */

import '../soap/soap_request.dart';
import '../soap/soap_response.dart';
//Use implementation depending which library is available.
//The mechanism is inspired from https://github.com/dart-lang/http/blob/master/lib/src/client.dart
import 'creation_stub.dart'
    if (dart.library.html) 'browser_client.dart'
    if (dart.library.io) 'io_client.dart';

/// Defines the interface which all clients must implement
///
abstract class SoapClient {
  /// When connecting to a new host exceeds this timeout, a [SocketException]
  /// is thrown. The timeout applies only to connections initiated after the
  /// timeout is set.
  ///
  /// When this is `null`, the OS default timeout is used. The default is
  /// `null`.
  /// Excerpt from [HttpClient.connectionTimeout]
  final Duration? timeOutDuration;

  /// Creates a [SoapClient] with the specified [timeOutDuration].
  SoapClient(this.timeOutDuration);

  /// The communication with a service is here implemented.
  Future<SoapResponse> sendRequest(
      SoapRequest soapRequest, String authorizationToken);

  /// Called to create a SoapClient independent of the platform.
  factory SoapClient.create(Duration? timeOutDuration) =>
      createClient(timeOutDuration);
}
