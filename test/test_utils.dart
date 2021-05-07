/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: test_utils.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'dart:io';

import 'package:animaltracing_unofficial_binding/core/core.dart';
import 'package:xml/xml.dart';

/// A mock implementation of a type used for making a request.
class MockRequestData extends RequestData {
  @override
  void generateWith(XmlBuilder builder, String? elementName) {
    builder.element(elementName ?? 'MockRequestData', nest: 'testData');
  }
}

/// Signature to handle a request
///
/// The implementer is responsible to call request.response.close() .
typedef RequestHandler = Future<void> Function(HttpRequest request);

/// Portnumber on which a testserver listens.
const _portNumber = 4041;

/// ServiceEndpointConfiguration used to connect temporary test servers. See [createServer]
final testServerConfiguration =
    ServiceEndpointConfiguration('localhost', _portNumber, 'test');

/// Sets up a Server with the following Configuration:
/// IPAddress: loopbackIPv4, port: 4041
///
/// [HttpRequest]s need to be handled by [requestHandler].
Future<HttpServer> createServer(RequestHandler requestHandler) async {
  final server =
      await HttpServer.bind(InternetAddress.loopbackIPv4, _portNumber);
  server.listen((request) {
    requestHandler(request);
  });
  return server;
}
