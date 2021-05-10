/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: get_ear_tag_orders_response.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:xml/xml.dart';

import '../core/core.dart';
import '../shared_types/ear_tag_order_data.dart';
import '../shared_types/processing_result.dart';
import '../src/xml_utils.dart';

class GetEarTagOrdersResponse extends ResponseData {
  final ProcessingResult? result;
  final List<EarTagOrderData>? resultDetails;

  const GetEarTagOrdersResponse(this.result, this.resultDetails);

  factory GetEarTagOrdersResponse.fromXml(XmlElement element) {
    if (element.name.local != 'GetEarTagOrdersResponse') {
      throw FormatException(
          'element passed to GetEarTagOrdersResponse.fromXml is not a '
          'GetEarTagOrdersResponse from $animalTracingNameSpace',
          element.toXmlString(pretty: true));
    }
    final getEarTagOrdersResultElement = element
        .getElement('GetEarTagOrdersResult', namespace: animalTracingNameSpace);
    if (getEarTagOrdersResultElement == null) {
      throw FormatException('Could not find GetEarTagOrdersResult',
          element.toXmlString(pretty: true));
    }

    final resultElement = getEarTagOrdersResultElement.extractValue<XmlElement>(
        'Result', animalTracingNameSpace, NullabilityType.required);
    ProcessingResult? result;
    if (resultElement != null) {
      result = ProcessingResult.fromXml(resultElement);
    }

    final resultDetailsElement =
        getEarTagOrdersResultElement.extractValue<XmlElement>(
            'Resultdetails', animalTracingNameSpace, NullabilityType.required);

    List<EarTagOrderData>? resultDetails;
    if (resultDetailsElement != null) {
      resultDetails = resultDetailsElement.extractList<EarTagOrderData>(
          'EarTagOrderDataItem',
          animalTracingNameSpace,
          (element) => EarTagOrderData.fromXml(element),
          NullabilityType.required);
    }
    return GetEarTagOrdersResponse(result, resultDetails);
  }
}
