/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: io_client_test.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'dart:io';

import 'package:animaltracing_unofficial_binding/animaltracing_unofficial_binding.dart';
import 'package:animaltracing_unofficial_binding/src/internal/soap_client/envelopes/soap_request.dart';
import 'package:animaltracing_unofficial_binding/src/internal/soap_client/plattform_implementations/io_client.dart';
import 'package:test/test.dart';

import '../../test_utils/test_utils.dart';

void main() {
  group('IOClient', () {
    //TODO: rework Test using spawnHybridUri
    //See:https://pub.dev/documentation/test_api/latest/test_api.scaffolding/spawnHybridUri.html
    group('TimeOutSetup', () {
      late HttpServer server;
      setUp(() async {
        server = await createServer((request) async {
          // ignore: inference_failure_on_instance_creation
          await Future.delayed(const Duration(days: 10));
          await request.response.close();
        });
      });
      tearDown(() {
        server.close(force: true);
      });
      test('throws SocketException', () async {
        final client = IOClient(const Duration(milliseconds: 500));
        final soapRequest = SoapRequest(
            testServerConfiguration, 'serviceOperation', MockRequestData());
        expect(
            () async => client.sendRequest(soapRequest, 'authorizationToken'),
            throwsA(const TypeMatcher<HttpException>()));
      },
          tags: ['exception-model'],
          timeout: const Timeout(Duration(seconds: 5)),
          skip: true);
    });
    test(
        'ServiceEndpointConfiguration pointing to not existing Service throws '
        'SocketException', () {
      final client = IOClient(const Duration(milliseconds: 500));
      final soapRequest = SoapRequest(
          ConnectionConfiguration(
              endpoint: Uri.http('localhost:4042', 'Livestock/AnimalTracing/3'),
              connectionTimeout: const Duration(milliseconds: 500)),
          'serviceOperation',
          MockRequestData());
      expect(() async => client.sendRequest(soapRequest, 'authorizationToken'),
          throwsA(const TypeMatcher<SocketException>()));
    }, tags: ['exception-model']);
    group('HttpStatusCodeNot200Setup', () {
      late HttpServer server;
      setUp(() async {
        server = await createServer((request) async {
          request.response.statusCode = HttpStatus.badRequest;
          await request.response.close();
        });
      });
      tearDown(() {
        server.close(force: true);
      });
      test('throws HttpException', () {
        final client = IOClient(const Duration(milliseconds: 500));
        final soapRequest = SoapRequest(
            testServerConfiguration, 'serviceOperation', MockRequestData());
        expect(
            () async => client.sendRequest(soapRequest, 'authorizationToken'),
            throwsA(const TypeMatcher<HttpException>()));
      }, tags: ['exception-model']);
    });
    group('HttpStatusCodeNot200WithSoapEnvelopeSetup', () {
      late HttpServer server;
      setUp(() async {
        server = await createServer((request) async {
          request.response.statusCode = HttpStatus.badRequest;
          const envelopeWithFault = '''
          <env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope">
             <env:Body>
                <env:Fault>
                   <env:Code>
                      <env:Value>env:Sender</env:Value>
                   </env:Code>
                   <env:Reason>
                      <env:Text>FormatException: Add To from http://www.w3.org/2005/08/addressing to Header</env:Text>
                   </env:Reason>
                </env:Fault>
             </env:Body>
          </env:Envelope>''';
          request.response.writeln(envelopeWithFault);
          request.response.headers.contentType =
              ContentType('application', 'soap+xml', charset: 'utf-8');
          await request.response.close();
        });
      });
      tearDown(() {
        server.close(force: true);
      });
      test('throws SoapException', () {
        final client = IOClient(const Duration(milliseconds: 500));
        final soapRequest = SoapRequest(
            testServerConfiguration, 'serviceOperation', MockRequestData());
        expect(
            () async => client.sendRequest(soapRequest, 'authorizationToken'),
            throwsA(const TypeMatcher<SoapException>()));
      }, tags: ['exception-model']);
    });
  }, onPlatform: const {'!dart-vm': Skip('Might not support IOClient')});
}
