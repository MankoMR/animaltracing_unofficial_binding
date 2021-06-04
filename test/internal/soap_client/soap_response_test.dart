/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: 
 * Project: animaltracing_unofficial_binding.
 */

import 'package:animaltracing_unofficial_binding/animaltracing_unofficial_binding.dart';
import 'package:animaltracing_unofficial_binding/src/internal/soap_client/envelopes/soap_response.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('SoapResponse', () {
    test('throws XmlParseException with invalid Xml', () {
      const invalidXml = '<<>';
      expect(() => SoapResponse(invalidXml),
          throwsA(const TypeMatcher<XmlParserException>()));
    }, tags: ['exception-model']);
    test('throws not XmlParseException with valid Xml', () {
      const invalidXml = '<Hello/>';
      expect(() => SoapResponse(invalidXml),
          throwsA(isNot(isA<XmlParserException>())));
    }, tags: ['exception-model']);
    test('throws  XmlMissingElementException when something is missing', () {
      const invalidXml = '<Hello/>';
      expect(() => SoapResponse(invalidXml),
          throwsA(isA<XmlMissingElementException>()));
    }, tags: ['exception-model']);
    test('throws  XmlMissingElementException when soap:Body is missing', () {
      const envelopeWithMissingBody = '''
      <env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope">
      </env:Envelope>''';
      expect(() => SoapResponse(envelopeWithMissingBody),
          throwsA(isA<XmlMissingElementException>()));
    }, tags: ['exception-model']);
    test(
        'throws  XmlMissingElementException when soap:Reason is missing '
        '(partially)', () {
      const envelopeWithmissingReasong = '''
      <env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope">
         <env:Body>
            <env:Fault>
               <env:Code>
                  <env:Value>env:Sender</env:Value>
               </env:Code>
               <env:Reason>
               </env:Reason>
            </env:Fault>
         </env:Body>
      </env:Envelope>''';
      expect(() => SoapResponse(envelopeWithmissingReasong),
          throwsA(isA<XmlMissingElementException>()));
    }, tags: ['exception-model']);
    test('throws SoapException', () {
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
      expect(
          () => SoapResponse(envelopeWithFault), throwsA(isA<SoapException>()));
      try {
        SoapResponse(envelopeWithFault);
      } on SoapException catch (exception) {
        expect(exception.errorCode, 'env:Sender');
        expect(exception.message,
            'FormatException: Add To from http://www.w3.org/2005/08/addressing to Header');
      }
    });
  });
}
