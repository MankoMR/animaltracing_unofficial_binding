/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: core.dart
 * Projekt animaltracing_unofficial_binding.
 */
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

/// Base class for all Topics.
///
/// Specifies how to get the [ServiceEndpointConfiguration]
abstract class TopicBase {
  ///Contains necessary information for connecting to a service-endpoint.
  ///
  /// See [ServiceEndpointConfiguration] for more information.
  ServiceEndpointConfiguration get serviceEndpointConfiguration;
}

/// Base class which must be implemented by all data types which can be sent with
/// a request.
///
/// If a data types contains other classes which implement [RequestData],
/// [generateWith] must be called at the approriate position in [generateWith]
/// the data type.
abstract class RequestData {
  /// Creates a [RequestData].
  ///
  /// Used to Classes which extend [RequestData] to have a const constructors,
  /// as well as generative Constructors.
  const RequestData();

  /// Generates the xml for the corresponding service operation.
  ///
  /// Must be implemented by all data types which will be sent to a service
  /// endpoint.
  @mustCallSuper
  void generateWith(XmlBuilder builder, String? elementName);
}

/// Base class which must be implemented by all data types which can be received
/// as part of a response.
abstract class ResponseData {
  /// Creates a [ResponseData].
  ///
  /// Used to Classes which extend [ResponseData] to have a const constructors,
  /// as well as generative Constructors.
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

  /// The port number on which the service is available.
  final int port;

  /// Path of the webadress.
  ///
  /// Example: Livestock/AnimalTracing/3
  ///
  /// There should be no '/' at the beginning.
  final String path;

  /// Gets and sets the connection timeout.
  ///
  /// When connecting to a new host exceeds this timeout, a [SocketException]
  /// is thrown. The timeout applies only to connections initiated after the
  /// timeout is set.
  ///
  /// When this is `null`, the OS default timeout is used. The default is
  /// `null`.
  ///
  /// See [HttpClient.connectionTimeout] for more details.
  final Duration? timeOutDuration;

  /// Create [ServiceEndpointConfiguration].
  ///
  /// [path] should not start with '/' at the beginning.
  ///
  /// See documentation of the members for additional infos.
  ServiceEndpointConfiguration(
      this.host, this.port, String path, this.timeOutDuration)
      : path = path;
}
