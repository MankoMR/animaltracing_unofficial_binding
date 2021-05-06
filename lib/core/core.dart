/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: core.dart
 * Projekt animaltracing_unofficial_binding.
 */
import 'package:xml/xml.dart';

abstract class TopicBase {
  String get serviceEndpoint;
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
