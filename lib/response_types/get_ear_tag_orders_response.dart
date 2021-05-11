/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: get_ear_tag_orders_response.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:xml/xml.dart';

import '../core/core.dart';
import '../request_types/get_ear_tag_orders_request.dart';
import '../shared_types/ear_tag_order_data.dart';
import '../shared_types/processing_result.dart';
import '../src/xml_utils/parsing.dart';

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
          'GetEarTagOrdersResponse from ${Namespaces.animalTracing}',
          element.toXmlString(pretty: true));
    }
    final getEarTagOrdersResultElement = element.extractValue<XmlElement>(
        'GetEarTagOrdersResult', Namespaces.animalTracing,
        isNillable: true, isElementOptional: true);
    if (getEarTagOrdersResultElement == null) {
      return GetEarTagOrdersResponse(null, null);
    }

    final resultElement = getEarTagOrdersResultElement.extractValue<XmlElement>(
        'Result', Namespaces.animalTracing,
        isNillable: true);
    ProcessingResult? result;
    if (resultElement != null) {
      result = ProcessingResult.fromXml(resultElement);
    }

    final resultDetailsElement = getEarTagOrdersResultElement
        .extractValue<XmlElement>('Resultdetails', Namespaces.animalTracing,
            isNillable: true);

    List<EarTagOrderData>? resultDetails;
    if (resultDetailsElement != null) {
      resultDetails = resultDetailsElement.extractList<EarTagOrderData>(
          'EarTagOrderDataItem',
          Namespaces.animalTracing,
          (element) => EarTagOrderData.fromXml(element),
          NullabilityType.required);
    }
    return GetEarTagOrdersResponse(result, resultDetails);
  }
}
