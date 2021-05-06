/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: core.dart
 * Projekt animaltracing_unofficial_binding.
 */
import 'package:xml/xml.dart';

abstract class TopicBase {
  ServiceEndpointConfiguration get serviceEndpointConfiguration;
}

abstract class RequestData {
  void generateWith(XmlBuilder builder, String? elementName);
}

abstract class ResponseData {
  factory ResponseData.fromXml(XmlElement element) {
    throw UnimplementedError(
        'call constructor from classes which extend or implement from ResponseData');
  }
}

///Holds information to connect a service endpoint
class ServiceEndpointConfiguration {
  ///Name of the host.
  ///
  /// Could be ipAddress or domain name.
  final String host;
  final int port;

  ///Path of the webadress.
  ///
  /// Example: Livestock/AnimalTracing/3
  final String path;

  ServiceEndpointConfiguration(this.host, this.port, this.path);
}
