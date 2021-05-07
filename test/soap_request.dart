/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: 
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/core/core.dart';
import 'package:animaltracing_unofficial_binding/src/soap/soap_request.dart';
import 'package:animaltracing_unofficial_binding/src/xml_utils.dart';
import 'package:test/test.dart';
import 'package:xml/src/xml/builder.dart';

void main() {
  group('SoapRequest', () {
    test('root element is soap:Envelop', () {
      final envelope = SoapRequest(
              ServiceEndpointConfiguration('localhost', 1, 'test'),
              'serviceOperation',
              MockRequestData())
          .generateEnvelope();
      expect(envelope.rootElement.name.local, 'Envelope');
      expect(envelope.rootElement.name.namespaceUri, soapNameSpace);
      expect(envelope.rootElement.firstElementChild?.name.local, 'Header');
      expect(envelope.rootElement.firstElementChild?.name.namespaceUri,
          soapNameSpace);

      expect(envelope.rootElement.lastElementChild?.name.local, 'Body');
      expect(envelope.rootElement.firstElementChild?.name.namespaceUri,
          soapNameSpace);
    });
    test('soap:Header contains action and to with correct value', () {
      final envelope = SoapRequest(
              ServiceEndpointConfiguration('localhost', 1, 'test'),
              'serviceOperation',
              MockRequestData())
          .generateEnvelope();
      final headerElement = envelope.rootElement.firstElementChild;
      expect(
          headerElement
              ?.getElement('To', namespace: adressingNameSpace)
              ?.innerText,
          'localhost:1/test');
      expect(
          headerElement
              ?.getElement('Action', namespace: adressingNameSpace)
              ?.innerText,
          'serviceOperation');
    });
    test('soap:Body contains correct data', () {
      final envelope = SoapRequest(
              ServiceEndpointConfiguration('localhost', 1, 'test'),
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

class MockRequestData extends RequestData {
  @override
  void generateWith(XmlBuilder builder, String? elementName) {
    builder.element(elementName ?? 'MockRequestData', nest: 'testData');
  }
}