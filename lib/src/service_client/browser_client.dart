/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: browser_client.dart
 * Project: animaltracing_unofficial_binding.
 */
import '../soap/soap_request.dart';
import '../soap/soap_response.dart';
import 'soap_client.dart';

/// Implementation of [SoapClient] for when library is used in the browser.
class BrowserClient extends SoapClient {
  /// Creates a [BrowserClient] with the specified [timeOutDuration].
  BrowserClient(Duration? timeOutDuration) : super(timeOutDuration);

  /// Sends the [soapRequest] to the service as specified in
  /// [ServiceEndpointConfiguration].
  @override
  Future<SoapResponse> sendRequest(
      SoapRequest soapRequest, String authorizationToken) async {
    // TODO: implement sendRequest
    throw UnimplementedError();
  }
}

/// Creates a [BrowserClient] with the specified [timeOutDuration].
///
/// Function ist called depending on which library is available.
/// See the imports in the sourcecode for [SoapClient]
SoapClient createClient(Duration? timeOutDuration) =>
    BrowserClient(timeOutDuration);
