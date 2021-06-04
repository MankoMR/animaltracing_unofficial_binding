/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: 
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/animaltracing_unofficial_binding.dart';
import 'package:animaltracing_unofficial_binding/src/internal/soap_client/envelopes/soap_request.dart';
import 'package:animaltracing_unofficial_binding/src/internal/xml_utils/shared.dart';
import 'package:test/test.dart';

import '../../test_utils/test_utils.dart';

void main() {
  group('SoapRequest', () {
    test('root element is soap:Envelop', () {
      final envelope = SoapRequest(
              ConnectionConfiguration(
                  endpoint: Uri.http('localhost:1', 'test')),
              'serviceOperation',
              MockRequestData())
          .generateEnvelope();
      expect(envelope.rootElement.name.local, 'Envelope');
      expect(envelope.rootElement.name.namespaceUri, Namespaces.soap);
      expect(envelope.rootElement.firstElementChild?.name.local, 'Header');
      expect(envelope.rootElement.firstElementChild?.name.namespaceUri,
          Namespaces.soap);

      expect(envelope.rootElement.lastElementChild?.name.local, 'Body');
      expect(envelope.rootElement.firstElementChild?.name.namespaceUri,
          Namespaces.soap);
    });
    test('soap:Header contains action and to with correct value', () {
      final envelope = SoapRequest(
              ConnectionConfiguration(
                  endpoint: Uri.http('localhost:1', 'test')),
              'serviceOperation',
              MockRequestData())
          .generateEnvelope();
      final headerElement = envelope.rootElement.firstElementChild;
      expect(
          headerElement
              ?.getElement('To', namespace: Namespaces.addressing)
              ?.innerText,
          'localhost:1/test');
      expect(
          headerElement
              ?.getElement('Action', namespace: Namespaces.addressing)
              ?.innerText,
          'serviceOperation');
    });
    test('soap:Body contains correct data', () {
      final envelope = SoapRequest(
              ConnectionConfiguration(
                  endpoint: Uri.http('localhost:1', 'test')),
              'serviceOperation',
              MockRequestData())
          .generateEnvelope();
      final mockRequestElement =
          envelope.rootElement.lastElementChild?.firstElementChild;
      expect(mockRequestElement?.name.local, 'MockRequestData');
      expect(mockRequestElement?.innerText, 'testData');
    });
  });
}
