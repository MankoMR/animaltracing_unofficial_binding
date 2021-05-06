/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: soap_request.dart
 * Project: animaltracing_unofficial_binding.
 */
import '../../core/core.dart';

class SoapRequest {
  final String serviceEndPoint;
  final String serviceOperation;
  final RequestData requestData;

  SoapRequest(this.serviceEndPoint, this.serviceOperation, this.requestData);

  String generateEnvelope() {
    throw UnimplementedError();
  }
}
