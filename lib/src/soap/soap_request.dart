/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: soap_request.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/src/xml_utils.dart';
import 'package:xml/xml.dart';

import '../../core/core.dart';

class SoapRequest {
  final ServiceEndpointConfiguration serviceEndpointConfiguration;
  final String serviceOperation;
  final RequestData requestData;

  SoapRequest(this.serviceEndpointConfiguration, this.serviceOperation,
      this.requestData);

  String generateEnvelope() {
    final builder = XmlBuilder(optimizeNamespaces: true);

    builder.element('Envelope',
        namespace: soapNameSpace, namespaces: nameSpaceMapping, nest: () {
      builder.element('Header', namespace: soapNameSpace, nest: () {
        builder.element('Action',
            namespace: adressingNameSpace, nest: serviceOperation);
        final serviceEndpoint = '${serviceEndpointConfiguration.host}:'
            '${serviceEndpointConfiguration.port}/'
            '${serviceEndpointConfiguration.path}';
        builder.element('To',
            namespace: adressingNameSpace, nest: serviceEndpoint);
      });
      builder.element('Body', namespace: soapNameSpace, nest: () {
        requestData.generateWith(builder, null);
      });
    });
    //TODO: Revisit when text from User is sent. There could be problems with whitespace.
    return builder.buildDocument().toXmlString(pretty: true);
  }
}
