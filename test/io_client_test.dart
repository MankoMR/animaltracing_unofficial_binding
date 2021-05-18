/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: io_client_test.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'dart:io';

import 'package:animaltracing_unofficial_binding/core/core.dart';
import 'package:animaltracing_unofficial_binding/exceptions/http_exception.dart';
import 'package:animaltracing_unofficial_binding/exceptions/soap_exception.dart';
import 'package:animaltracing_unofficial_binding/src/service_client/io_client.dart';
import 'package:animaltracing_unofficial_binding/src/soap/soap_request.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('IOClient', () {
    group('TimeOutSetup', () {
      late HttpServer server;
      setUp(() async {
        server = await createServer((request) async {
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
            () async =>
                await client.sendRequest(soapRequest, 'authorizationToken'),
            throwsA(const TypeMatcher<HttpException>()));
        //TODO: remove skipping test once reason Test fails is clear
      },
          tags: ['errors'],
          timeout: const Timeout(Duration(seconds: 5)),
          skip: true);
    });
    test(
        'ServiceEndpointConfiguration pointing to not existing Service throws '
        'SocketException', () {
      final client = IOClient(const Duration(milliseconds: 500));
      final soapRequest = SoapRequest(
          ServiceEndpointConfiguration('localhost', 4042,
              'Livestock/AnimalTracing/3', const Duration(milliseconds: 500)),
          'serviceOperation',
          MockRequestData());
      expect(
          () async =>
              await client.sendRequest(soapRequest, 'authorizationToken'),
          throwsA(const TypeMatcher<SocketException>()));
    }, tags: ['errors']);
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
            () async =>
                await client.sendRequest(soapRequest, 'authorizationToken'),
            throwsA(const TypeMatcher<HttpException>()));
      }, tags: ['errors']);
    });
    group('HttpStatusCodeNot200WithSoapEnvelopeSetup', () {
      late HttpServer server;
      setUp(() async {
        server = await createServer((request) async {
          request.response.statusCode = HttpStatus.badRequest;
          const envelopeWithFault =
              '''<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope">
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
            () async =>
                await client.sendRequest(soapRequest, 'authorizationToken'),
            throwsA(const TypeMatcher<SoapException>()));
      }, tags: ['errors']);
    });
  }, onPlatform: const {'!dart-vm': Skip('Might not support IOClient')});
}
