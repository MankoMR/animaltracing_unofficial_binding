/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: io_client.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'dart:convert';
import 'dart:io';

import '../../core/core.dart';
import '../../exceptions/http_exception.dart';
import '../../exceptions/library_exception.dart';
import '../../exceptions/soap_exception.dart';
import '../../exceptions/string_decoding_exception.dart';
import '../../exceptions/xml_missing_element_exception.dart';
import '../../exceptions/xml_parse_exception.dart';
import '../soap/soap_request.dart';
import '../soap/soap_response.dart';
import 'soap_client.dart';

/// Used in case when access to the dart:io library is available.
///
/// This implementation will be used in most cases.
class IOClient extends SoapClient {
  IOClient(Duration? timeOutDuration) : super(timeOutDuration);

  /// Sends the [soapRequest] to the service as specified in [ServiceEndpointConfiguration].
  ///
  /// May throw the following exceptions: [SoapException],[HttpException],
  /// [StringDecodingException],[XmlParseException],[XmlMissingElementException].
  ///
  /// In some Scenarios it could also throw other Exceptions.
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
    //TODO: Revisit when text from User is sent. There could be problems with whitespace.
    request.write(soapRequest.generateEnvelope().toXmlString(pretty: true));

    final response = await request.close();
    client.close();

    final content = await _decodeContent(response);

    //This code is added because the service could respond
    //with an soap:Envelope which could contain additional information
    //why its a bad request.
    if (response.statusCode != HttpStatus.ok) {
      try {
        SoapResponse(content);
      } on SoapException {
        rethrow;
      } on LibraryException {
        throw HttpException(response.statusCode, response.reasonPhrase);
      }
    }
    return SoapResponse(content);
  }

  /// Decodes content of response.
  ///
  /// Throws [StringDecodingException] is response is not according to charset specification.
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
      //Drain to avoid leaking resources.
      await response.drain();
      throw StringDecodingException(exception);
    }
  }
}

/// Function ist called depending which library is available. See the imports in
/// the sourcecode for [SoapClient]
SoapClient createClient(Duration? timeOutDuration) => IOClient(timeOutDuration);
