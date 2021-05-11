/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: get_ear_tag_orders_response.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/request_types/get_ear_tag_orders_request.dart';
import 'package:xml/xml.dart';

import '../core/core.dart';
import '../shared_types/ear_tag_order_data.dart';
import '../shared_types/processing_result.dart';
import '../src/xml_utils.dart';

/// The response to getEarTagOrders.
///
/// Look at [ProcessingResult] and [EarTagOrderData] for more information.
class GetEarTagOrdersResponse extends ResponseData {
  /// Contains information how the request got processed.
  final ProcessingResult? result;

  /// List of filtered eartag orders according to [GetEarTagOrdersRequest].
  final List<EarTagOrderData>? resultDetails;

  /// Create [GetEarTagOrdersResponse]
  const GetEarTagOrdersResponse(this.result, this.resultDetails);

  /// Used to create [EarTagOrderData] from a service response.
  ///
  /// The [element] should be xml-element in which the information is stored.
  factory GetEarTagOrdersResponse.fromXml(XmlElement element) {
    if (element.name.local != 'GetEarTagOrdersResponse') {
      throw FormatException(
          'element passed to GetEarTagOrdersResponse.fromXml is not a '
          'GetEarTagOrdersResponse from $animalTracingNameSpace',
          element.toXmlString(pretty: true));
    }
    final getEarTagOrdersResultElement = element.extractValue<XmlElement>(
        'GetEarTagOrdersResult', animalTracingNameSpace,
        isNillable: true, isElementOptional: true);
    if (getEarTagOrdersResultElement == null) {
      return GetEarTagOrdersResponse(null, null);
    }

    final resultElement = getEarTagOrdersResultElement.extractValue<XmlElement>(
        'Result', animalTracingNameSpace,
        isNillable: true);
    ProcessingResult? result;
    if (resultElement != null) {
      result = ProcessingResult.fromXml(resultElement);
    }

    final resultDetailsElement = getEarTagOrdersResultElement
        .extractValue<XmlElement>('Resultdetails', animalTracingNameSpace,
            isNillable: true);

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
