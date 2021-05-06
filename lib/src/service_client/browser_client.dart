/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: browser_client.dart
 * Project: animaltracing_unofficial_binding.
 */
import '../soap/soap_request.dart';
import '../soap/soap_response.dart';
import 'base_client.dart';

class BrowserClient extends BaseClient {
  BrowserClient(Duration? timeOutDuration) : super(timeOutDuration);

  @override
  Future<SoapResponse> sendRequest(
      SoapRequest soapRequest, String authorizationToken) async {
    // TODO: implement sendRequest
    throw UnimplementedError();
  }
}

BaseClient createClient(Duration? timeOutDuration) =>
    BrowserClient(timeOutDuration);
