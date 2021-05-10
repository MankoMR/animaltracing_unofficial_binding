/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: eartags.dart
 * Project: animaltracing_unofficial_binding.
 */
import '../core/core.dart';
import '../exceptions/xml_missing_element_exception.dart';
import '../request_types/get_ear_tag_orders_request.dart';
import '../response_types/get_ear_tag_orders_response.dart';
import '../src/service_client/soap_client.dart';
import '../src/soap/soap_request.dart';
import '../src/xml_utils.dart';

class Eartags extends TopicBase {
  @override
  final ServiceEndpointConfiguration serviceEndpointConfiguration;

  Eartags(this.serviceEndpointConfiguration);

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
        namespace: animalTracingNameSpace);

    if (children == null) {
      throw XmlMissingElementException(
          'GetEarTagOrdersResponse', animalTracingNameSpace, null);
    }
    return GetEarTagOrdersResponse.fromXml(children);
  }
}
