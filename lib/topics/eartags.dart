/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: eartags.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'dart:io';

import 'package:xml/xml.dart';

import '../core/core.dart';
import '../exceptions/soap_exception.dart';
import '../exceptions/xml_missing_element_exception.dart';
import '../request_types/get_ear_tag_orders_request.dart';
import '../response_types/get_ear_tag_orders_response.dart';
import '../src/service_client/soap_client.dart';
import '../src/soap/soap_request.dart';
import '../src/xml_utils/shared.dart';

/// Eartags contains all service operations that involve eartags.
///
class Eartags extends TopicBase {
  /// Stores the configuration for connecting to a service endpoint.
  @override
  final ServiceEndpointConfiguration serviceEndpointConfiguration;

  /// Creates [Eartags] with [serviceEndpointConfiguration].
  ///
  /// Storing [serviceEndpointConfiguration] in a topic reduces the overhead to
  /// to use the service operations.
  Eartags(this.serviceEndpointConfiguration);

  /// Get the eartag-orders made in a certain time span.
  ///
  /// See [GetEarTagOrdersRequest] for detailed information how to create a
  /// request.
  ///
  /// The user needs to be a farm owner or a mandate holder for a farm, to use
  /// this operation. The government can also call this operation.
  ///
  /// May throw the following exceptions: [SoapException],[HttpException],
  /// [SocketException]. Those exception require special attention as they
  /// signal some issue that the library is unable to handle.
  ///
  /// If an error occurred while parsing an Exception that implements
  /// [FormatException] will be thrown. Here some examples what exceptions may
  /// be thrown: [StringDecodingException],[XmlParserException],
  /// [XmlMissingElementException].
  Future<GetEarTagOrdersResponse> getEarTagOrders(
      GetEarTagOrdersRequest requestData, String authorizationToken) async {
    const serviceOperationName =
        'http://www.admin.ch/xmlns/Services/evd/Livestock/AnimalTracing/1/AnimalTracingPortType/GetEarTagOrders';
    final soapRequest = SoapRequest(
        serviceEndpointConfiguration, serviceOperationName, requestData);
    final response =
        await SoapClient.create(serviceEndpointConfiguration.timeOutDuration)
            .sendRequest(soapRequest, authorizationToken);

    final children = response.body.getElement('GetEarTagOrdersResponse',
        namespace: Namespaces.animalTracing);

    if (children == null) {
      throw XmlMissingElementException(
          'GetEarTagOrdersResponse', Namespaces.animalTracing, null);
    }
    return GetEarTagOrdersResponse.fromXml(children);
  }
}
