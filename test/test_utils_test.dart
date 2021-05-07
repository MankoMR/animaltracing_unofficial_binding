/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: 
 * Project: animaltracing_unofficial_binding.
 */

import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('TestUtils', () {
    test('validateXml throws InvalidXml with invalid xml.', () {
      final invalidXml = buildXml(MockRequestData(), null);
      expect(() async => await validateXml(invalidXml),
          throwsA(TypeMatcher<InvalidXmlException>()));
    });
    test('validateXml returns normal with valid xml', () {
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
      expect(() async => await validateXml(envelopeWithFault), returnsNormally);
    });
  });
}
