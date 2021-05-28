/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: get_ear_tag_orders_response.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:xml/xml.dart';

import '../../../common_types/processing_result.dart';
import '../../../internal/base_types.dart';
import '../../../internal/xml_utils/parsing.dart';
import '../request_types/get_ear_tag_orders_request.dart';
import '../shared_types/ear_tag_order_data.dart';

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
    final getEarTagOrdersResultElement = element.extractXmlElement(
        'GetEarTagOrdersResult', Namespaces.animalTracing,
        isNullable: true, isOptional: true);
    if (getEarTagOrdersResultElement == null) {
      return const GetEarTagOrdersResponse(null, null);
    }

    final resultElement = getEarTagOrdersResultElement.extractXmlElement(
        'Result', Namespaces.animalTracing,
        isNullable: true);
    ProcessingResult? result;
    if (resultElement != null) {
      result = ProcessingResult.fromXml(resultElement);
    }

    final resultDetailsElement = getEarTagOrdersResultElement.extractXmlElement(
        'Resultdetails', Namespaces.animalTracing,
        isNullable: true);

    List<EarTagOrderData>? resultDetails;
    if (resultDetailsElement != null) {
      resultDetails = resultDetailsElement.extractList<EarTagOrderData>(
          'EarTagOrderDataItem',
          Namespaces.animalTracing,
          (element) => EarTagOrderData.fromXml(element),
          // ignore: deprecated_member_use_from_same_package
          NullabilityType.required);
    }
    return GetEarTagOrdersResponse(result, resultDetails);
  }
}
