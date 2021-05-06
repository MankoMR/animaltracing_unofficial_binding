/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: io_client.dart
 * Project: animaltracing_unofficial_binding.
 */
import '../soap/soap_request.dart';
import '../soap/soap_response.dart';
import 'base_client.dart';

class IOClient extends BaseClient {
  IOClient(DateTime timeOutDuration) : super(timeOutDuration);

  @override
  Future<SoapResponse> sendRequest(
      SoapRequest soapRequest, String authorizationToken) {
    throw UnimplementedError();
  }
}

BaseClient createClient(DateTime timeOutDuration) => IOClient(timeOutDuration);
