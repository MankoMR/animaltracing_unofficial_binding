/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: get_ear_tag_orders_response_test.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/eartags.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../../../test_utils/test_utils.dart';

void main() {
  group('GetEarTagOrdersResponse', () {
    test('parsing with all Fields filled', () async {
      const result =
          ProcessingResult(1, 'Verarbeitung erfolgreich durchgeführt', 1);
      final resultDetails = EarTagOrderData(
          BigInt.one,
          1,
          7,
          false,
          2,
          DateTime(2021, 4, 26, 13, 56, 46, 412533),
          'CH10000010',
          'CH10000017',
          'text1',
          'text2');
      final rawXml = '''
      <tns:GetEarTagOrdersResponse xmlns:tns="http://www.admin.ch/xmlns/Services/evd/Livestock/AnimalTracing/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
         <tns:GetEarTagOrdersResult>
            <tns:Result>
               <tns:Code>${result.code}</tns:Code>
               <tns:Description>${result.description}</tns:Description>
               <tns:Status>${result.status}</tns:Status>
            </tns:Result>
            <tns:Resultdetails>
               <tns:EarTagOrderDataItem>
                  <tns:NotificationID>${resultDetails.notificationId}</tns:NotificationID>
                  <tns:EarTagType>${resultDetails.earTagType}</tns:EarTagType>
                  <tns:Amount>${resultDetails.amount}</tns:Amount>
                  <tns:IsExpress>${resultDetails.isExpress}</tns:IsExpress>
                  <tns:OrderStatus>${resultDetails.orderStatus}</tns:OrderStatus>
                  <tns:OrderStatusDate>${resultDetails.orderStatusDate.toIso8601String()}</tns:OrderStatusDate>
                  <tns:EarTagNumberFrom>${resultDetails.earTagNumberFrom}</tns:EarTagNumberFrom>
                  <tns:EarTagNumberTo>${resultDetails.earTagNumberTo}</tns:EarTagNumberTo>
                  <tns:Text1>${resultDetails.text1}</tns:Text1>
                  <tns:Text2>${resultDetails.text2}</tns:Text2>
               </tns:EarTagOrderDataItem>
               <tns:EarTagOrderDataItem>
                  <tns:NotificationID>${resultDetails.notificationId}</tns:NotificationID>
                  <tns:EarTagType>${resultDetails.earTagType}</tns:EarTagType>
                  <tns:Amount>${resultDetails.amount}</tns:Amount>
                  <tns:IsExpress>${resultDetails.isExpress}</tns:IsExpress>
                  <tns:OrderStatus>${resultDetails.orderStatus}</tns:OrderStatus>
                  <tns:OrderStatusDate>${resultDetails.orderStatusDate.toIso8601String()}</tns:OrderStatusDate>
                  <tns:EarTagNumberFrom>${resultDetails.earTagNumberFrom}</tns:EarTagNumberFrom>
                  <tns:EarTagNumberTo>${resultDetails.earTagNumberTo}</tns:EarTagNumberTo>
                  <tns:Text1>${resultDetails.text1}</tns:Text1>
                  <tns:Text2>${resultDetails.text2}</tns:Text2>
               </tns:EarTagOrderDataItem>
            </tns:Resultdetails>
         </tns:GetEarTagOrdersResult>
      </tns:GetEarTagOrdersResponse>''';

      //Checks is valid xml.
      await expectIsValidXml(rawXml);

      final parsedXml = XmlDocument.parse(rawXml);
      final typedData = GetEarTagOrdersResponse.fromXml(parsedXml.rootElement);

      expect(typedData.result!.areSame(result), true);
      expect(typedData.resultDetails.length, equals(2));
      final parsedResultDetails = typedData.resultDetails[0];
      expect(parsedResultDetails.areSame(resultDetails), true);
    });
    test('parsing with leave elements nulled', () async {
      const result = ProcessingResult(1, null, 1);
      final resultDetails = EarTagOrderData(BigInt.one, 1, 7, false, 2,
          DateTime(2021, 4, 26, 13, 56, 46, 412533), null, null, null, null);
      final rawXml = '''
      <tns:GetEarTagOrdersResponse xmlns:tns="http://www.admin.ch/xmlns/Services/evd/Livestock/AnimalTracing/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
         <tns:GetEarTagOrdersResult>
            <tns:Result>
               <tns:Code>${result.code}</tns:Code>
               <tns:Description xsi:nil="true"/>
               <tns:Status>${result.status}</tns:Status>
            </tns:Result>
            <tns:Resultdetails>
               <tns:EarTagOrderDataItem>
                  <tns:NotificationID>${resultDetails.notificationId}</tns:NotificationID>
                  <tns:EarTagType>${resultDetails.earTagType}</tns:EarTagType>
                  <tns:Amount>${resultDetails.amount}</tns:Amount>
                  <tns:IsExpress>${resultDetails.isExpress}</tns:IsExpress>
                  <tns:OrderStatus>${resultDetails.orderStatus}</tns:OrderStatus>
                  <tns:OrderStatusDate>${resultDetails.orderStatusDate.toIso8601String()}</tns:OrderStatusDate>
                  <tns:EarTagNumberFrom xsi:nil="true"/>>
                  <tns:EarTagNumberTo xsi:nil="true"/>>
                  <tns:Text1xsi:nil="true"/>
                  <tns:Text2 xsi:nil="true"/>
               </tns:EarTagOrderDataItem>
            </tns:Resultdetails>
         </tns:GetEarTagOrdersResult>
      </tns:GetEarTagOrdersResponse>''';

      //Checks is valid xml.
      await expectIsValidXml(rawXml);

      final parsedXml = XmlDocument.parse(rawXml);
      final typedData = GetEarTagOrdersResponse.fromXml(parsedXml.rootElement);

      expect(typedData.result!.areSame(result), true);
      expect(typedData.resultDetails.length, equals(1));
      final parsedResultDetails = typedData.resultDetails[0];
      expect(parsedResultDetails.areSame(resultDetails), true);
    });
    test('parsing with ResultDetails empty', () async {
      const result = ProcessingResult(1, null, 1);
      final rawXml = '''
      <tns:GetEarTagOrdersResponse xmlns:tns="http://www.admin.ch/xmlns/Services/evd/Livestock/AnimalTracing/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
         <tns:GetEarTagOrdersResult>
            <tns:Result>
               <tns:Code>${result.code}</tns:Code>
               <tns:Description xsi:nil="true"/>
               <tns:Status>${result.status}</tns:Status>
            </tns:Result>
            <tns:Resultdetails/>
         </tns:GetEarTagOrdersResult>
      </tns:GetEarTagOrdersResponse>''';

      //Checks is valid xml.
      await expectIsValidXml(rawXml);

      final parsedXml = XmlDocument.parse(rawXml);
      final typedData = GetEarTagOrdersResponse.fromXml(parsedXml.rootElement);

      expect(typedData.result!.areSame(result), true);
      expect(typedData.resultDetails.isEmpty, isTrue);
    });
  });
}
