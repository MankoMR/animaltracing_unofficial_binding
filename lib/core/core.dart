/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: core.dart
 * Projekt animaltracing_unofficial_binding.
 */
import 'package:xml/xml.dart';

import '../exceptions/mal_formed_response_exception.dart';

/// Base class for all Topics.
///
/// Specifies how to get the [ServiceEndpointConfiguration]
abstract class TopicBase {
  ServiceEndpointConfiguration get serviceEndpointConfiguration;
}

/// Base class which must be implemented by all data types which can be sent with
/// a request.
///
/// If a data types contains other classes which implement [RequestData],
/// [generateWith] must be called at the approriate position in [generateWith]
/// the data type.
abstract class RequestData {
  const RequestData();

  void generateWith(XmlBuilder builder, String? elementName);
}

/// Base class which must be implemented by all data types which can be received
/// as part of a response.
abstract class ResponseData {
  const ResponseData();

  /// Signature which must be implemented.
  ///
  /// Exceptions thrown must implement [MalFormedResponseException]
  factory ResponseData.fromXml(XmlElement element) {
    throw UnimplementedError(
        'call constructor from classes which extend or implement from ResponseData');
  }
}

/// Holds information to connect a service endpoint
class ServiceEndpointConfiguration {
  /// Name of the host.
  ///
  /// Could be ipAddress or domain name.
  final String host;
  final int port;

  /// Path of the webadress.
  ///
  /// Example: Livestock/AnimalTracing/3
  final String path;

  final Duration? timeOutDuration;

  ServiceEndpointConfiguration(
      this.host, this.port, String path, this.timeOutDuration)
      : path = path.split('/').join('/');
}
