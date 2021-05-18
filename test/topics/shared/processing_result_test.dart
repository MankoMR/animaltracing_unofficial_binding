/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: processing_result_test.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/shared_types/processing_result.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('ProcessingResult Operation', () {
    test('parses all fields', () {
      const rawXml = '''
            <tns:Result xmlns:tns="http://www.admin.ch/xmlns/Services/evd/Livestock/AnimalTracing/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
               <tns:Code>1</tns:Code>
               <tns:Description>Verarbeitung erfolgreich durchgeführt</tns:Description>
               <tns:Status>1</tns:Status>
            </tns:Result>
''';
      final parsedXml = XmlDocument.parse(rawXml);
      final typedData = ProcessingResult.fromXml(parsedXml.rootElement);

      expect(
          typedData.areSame(const ProcessingResult(
              1, 'Verarbeitung erfolgreich durchgeführt', 1)),
          true);
    });
    test('parses required fields', () {
      const rawXml = '''
            <tns:Result xmlns:tns="http://www.admin.ch/xmlns/Services/evd/Livestock/AnimalTracing/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
               <tns:Code>1</tns:Code>
               <tns:Description xsi:nil="true"/>
               <tns:Status>1</tns:Status>
            </tns:Result>
''';
      final parsedXml = XmlDocument.parse(rawXml);
      final typedData = ProcessingResult.fromXml(parsedXml.rootElement);

      expect(typedData.areSame(const ProcessingResult(1, null, 1)), true);
    });
  });
}
