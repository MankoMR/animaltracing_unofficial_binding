/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: ear_tag_order_data_test.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/eartags.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../../../test_utils/test_utils.dart';

void main() {
  group('EarTagOrderData', () {
    test('parses all fields', () async {
      const rawXml = '''
               <tns:EarTagOrderData xmlns:tns="http://www.admin.ch/xmlns/Services/evd/Livestock/AnimalTracing/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                  <tns:NotificationID>1</tns:NotificationID>
                  <tns:EarTagType>1</tns:EarTagType>
                  <tns:Amount>7</tns:Amount>
                  <tns:IsExpress>false</tns:IsExpress>
                  <tns:OrderStatus>2</tns:OrderStatus>
                  <tns:OrderStatusDate>2021-04-26T13:56:46</tns:OrderStatusDate>
                  <tns:EarTagNumberFrom>CH10000010</tns:EarTagNumberFrom>
                  <tns:EarTagNumberTo>CH10000017</tns:EarTagNumberTo>
                  <tns:Text1>Text1</tns:Text1>
                  <tns:Text2>Text2</tns:Text2>
               </tns:EarTagOrderData>
''';
      await expectIsValidXml(rawXml);
      final parsedXml = XmlDocument.parse(rawXml);
      final typedData = EarTagOrderData.fromXml(parsedXml.rootElement);

      expect(
          typedData.areSame(EarTagOrderData(
              BigInt.one,
              1,
              7,
              false,
              2,
              DateTime(2021, 4, 26, 13, 56, 46),
              'CH10000010',
              'CH10000017',
              'Text1',
              'Text2')),
          true);
    });
    test('parses required fields', () async {
      const rawXml = '''
               <tns:EarTagOrderData xmlns:tns="http://www.admin.ch/xmlns/Services/evd/Livestock/AnimalTracing/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                  <tns:NotificationID>1</tns:NotificationID>
                  <tns:EarTagType>1</tns:EarTagType>
                  <tns:Amount>7</tns:Amount>
                  <tns:IsExpress>false</tns:IsExpress>
                  <tns:OrderStatus>2</tns:OrderStatus>
                  <tns:OrderStatusDate>2021-04-26T13:56:46</tns:OrderStatusDate>
                  <tns:EarTagNumberFrom xsi:nil="true"/>
                  <tns:EarTagNumberTo xsi:nil="true"/>
                  <tns:Text1 xsi:nil="true"/>
                  <tns:Text2 xsi:nil="true"/>
               </tns:EarTagOrderData>
''';
      await expectIsValidXml(rawXml);
      final parsedXml = XmlDocument.parse(rawXml);
      final typedData = EarTagOrderData.fromXml(parsedXml.rootElement);
      final expectedData = EarTagOrderData(BigInt.one, 1, 7, false, 2,
          DateTime(2021, 4, 26, 13, 56, 46), null, null, null, null);

      expect(typedData.areSame(expectedData), true,
          reason: 'parsed: \n${typedData.toStringRepresentation()}\n'
              'expected:\n${expectedData.toStringRepresentation()}');
    });
  });
}
