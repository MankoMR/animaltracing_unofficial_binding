/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: eartags.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'dart:io';

import 'package:xml/xml.dart';

import 'animaltracing_unofficial_binding.dart';
import 'src/internal/base_types.dart';
import 'src/internal/soap_client/soap_client.dart';
import 'src/internal/xml_utils/parsing.dart';
import 'src/topics/eartags/request_types/get_ear_tag_orders_request.dart';
import 'src/topics/eartags/response_types/get_ear_tag_orders_response.dart';

export 'src/common_types/processing_result.dart';
export 'src/topics/eartags/request_types/get_ear_tag_orders_request.dart';
export 'src/topics/eartags/response_types/get_ear_tag_orders_response.dart';
export 'src/topics/eartags/shared_types/ear_tag_order_data.dart';

/// Contains all service operations that involve eartags.
///
class Eartags extends TopicBase {
  /// Stores the configuration for connecting to a service endpoint.
  @override
  final ConnectionConfiguration connectionConfiguration;

  /// Creates [Eartags] with [connectionConfiguration].
  ///
  /// Storing [connectionConfiguration] in a topic reduces the overhead to
  /// to use the service operations.
  Eartags(this.connectionConfiguration);

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
    final soapRequest =
        SoapRequest(connectionConfiguration, serviceOperationName, requestData);
    final response =
        await SoapClient.create(connectionConfiguration.connectionTimeout)
            .sendRequest(soapRequest, authorizationToken);

    final children = response.body.extractXmlElement(
        'GetEarTagOrdersResponse', Namespaces.animalTracing)!;
    return GetEarTagOrdersResponse.fromXml(children);
  }
}
