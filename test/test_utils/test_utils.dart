/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: test_utils.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'dart:convert';
import 'dart:io';

import 'package:animaltracing_unofficial_binding/animaltracing_unofficial_binding.dart';
import 'package:animaltracing_unofficial_binding/src/internal/base_types.dart';
import 'package:test/expect.dart';
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

/// ServiceEndpointConfiguration used to connect temporary test servers. See
/// [createServer].
final testServerConfiguration = ConnectionConfiguration(
    endpoint: Uri.http('localhost:$_portNumber', 'test'));

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

/// Validates [data] against the schemas contained in the WSDL of
/// AnimalTracing.
///
/// Throws [UnsupportedError] if something is fundamentally wrong.
Future<void> expectGeneratesValidXml(
    RequestData data, String? elementName) async {
  final rawXml = generateXml(data, elementName);
  final result = await validateXml(rawXml);
  expect(result.isValidXml, true, reason: '$rawXml\n${result.message}');
}

/// Validates [rawXml] against the schemas contained in the WSDL of
/// Animaltracing.
///
/// Throws [UnsupportedError] if something is fundamentally wrong.
Future<void> expectIsValidXml(String rawXml) async {
  final result = await validateXml(rawXml);
  expect(result.isValidXml, true, reason: result.message);
}

/// Simplifies getting xml-String from [data].
String generateXml(RequestData data, String? elementName) {
  final builder = XmlBuilder(optimizeNamespaces: true);
  data.generateWith(builder, elementName);
  return builder.buildDocument().toXmlString(pretty: true);
}

/// Validates [xml] against the schemas contained in the wsdl-Definiton of
/// AnimalTracing.
///
/// Returns [ValidationResult] with information about XML-schema validation.
///
/// Throws [UnsupportedError] if something is fundamentally wrong.
Future<ValidationResult> validateXml(String xml) async {
  final encodedXml = base64.encode(xml.codeUnits);

  // ignore: lines_longer_than_80_chars
  //Todo: Change when support for additional systems will be added.
  final processingResult = await Process.run(
      r'.\tool\xml_validator\windows-x86\animaltracing_xml_validator.exe',
      ['--xmlBase64=$encodedXml']);

  //I called animaltracing_xml_validator.exe --help to get information
  // which exitCode means what.
  switch (processingResult.exitCode) {
    case 0:
    case 2:
    case 3:
      return ValidationResult(
          processingResult.exitCode, processingResult.stdout as String);
    case 1:
    case 4:
    default:
      //In this case something needs to be reworked.
      throw UnsupportedError(
          'Something Unexpected happend: ${processingResult.stdout}');
  }
}

class ValidationResult {
  final int code;
  final String message;

  bool get isValidXml => code == 0;

  ValidationResult(this.code, this.message);
}
