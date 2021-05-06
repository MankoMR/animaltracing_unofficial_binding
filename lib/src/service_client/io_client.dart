/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: io_client.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'dart:convert';
import 'dart:io';

import '../../exceptions/http_exception.dart';
import '../../exceptions/library_exception.dart';
import '../../exceptions/soap_exception.dart';
import '../../exceptions/string_decoding_exception.dart';
import '../soap/soap_request.dart';
import '../soap/soap_response.dart';
import 'base_client.dart';

class IOClient extends BaseClient {
  IOClient(Duration? timeOutDuration) : super(timeOutDuration);

  @override
  Future<SoapResponse> sendRequest(
      SoapRequest soapRequest, String authorizationToken) async {
    final client = HttpClient();
    client.connectionTimeout = timeOutDuration;
    final request = await client.post(
        soapRequest.serviceEndpointConfiguration.host,
        soapRequest.serviceEndpointConfiguration.port,
        soapRequest.serviceEndpointConfiguration.path);
    request.headers.contentType =
        ContentType('application', 'soap+xml', charset: 'utf-8');
    request.headers
        .add('Authorization', authorizationToken, preserveHeaderCase: true);
    request.write(soapRequest.generateEnvelope());

    final response = await request.close();
    client.close();

    final content = await _decodeContent(response);

    //This code is added because the service could respond
    //with an soap:Envelope which could contain additional information
    //why its a bad request.
    print(content);
    if (response.statusCode != HttpStatus.ok) {
      try {
        SoapResponse(content);
      } on SoapException {
        rethrow;
      } on LibraryException {
        throw HttpException(response.statusCode, response.reasonPhrase);
      }
    } else {
      return SoapResponse(content);
    }
    throw UnimplementedError();
  }

  ///Decodes content of response.
  ///
  /// Throws [FormatException] is response is according to charset specification.
  Future<String> _decodeContent(HttpClientResponse response) async {
    try {
      final typ = response.headers.contentType?.charset;
      switch (typ) {
        case 'ascii':
        case 'us-ascii':
          return await ascii.decoder.bind(response).join();
        case 'latin-1':
        case 'iso-8859-1':
          return await latin1.decoder.bind(response).join();
        case 'utf-8':
        case null:
        default:
          return await utf8.decoder.bind(response).join();
      }
    } on FormatException catch (exception) {
      throw StringDecodingException(exception);
    }
  }
}

BaseClient createClient(Duration? timeOutDuration) => IOClient(timeOutDuration);
