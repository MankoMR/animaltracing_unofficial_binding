/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: soap_request.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:xml/xml.dart';

import '../../../../animaltracing_unofficial_binding.dart';
import '../../base_types.dart';
import '../../xml_utils/generation.dart';

/// Contains all the information needed to call a service operation.
class SoapRequest {
  /// Information about the service endpoint.
  final ConnectionConfiguration connectionConfiguration;

  /// Which service operation will be called.
  final String serviceOperation;

  /// Information required to call the service operation.
  final RequestData requestData;

  /// Creates a [SoapRequest] with [connectionConfiguration],
  /// [serviceOperation] and [requestData] set to corresponding values.
  SoapRequest(
      this.connectionConfiguration, this.serviceOperation, this.requestData);

  /// Generates the content of message which will be sent to the service.
  XmlDocument generateEnvelope() {
    final builder = XmlBuilder(optimizeNamespaces: true);

    builder.element('Envelope',
        namespace: Namespaces.soap,
        namespaces: Namespaces.nameSpacesNames, nest: () {
      builder
        ..element('Header', namespace: Namespaces.soap, nest: () {
          builder
            ..element('Action',
                namespace: Namespaces.addressing, nest: serviceOperation)
            ..element('To',
                namespace: Namespaces.addressing,
                nest: connectionConfiguration.endpoint.toString());
        })
        ..element('Body', namespace: Namespaces.soap, nest: () {
          requestData.generateWith(builder, null);
        });
    });
    // ignore: lines_longer_than_80_chars
    //TODO: Revisit when text from User is sent. There could be problems with whitespace.
    return builder.buildDocument();
  }
}
