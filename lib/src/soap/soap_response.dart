/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: soap_response.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:xml/xml.dart';

import '../../exceptions/xml_parse_exception.dart';
import '../xml_utils.dart';

class SoapResponse {
  late final XmlElement body;
  late final XmlElement? exception;
  late final XmlElement? header;

  SoapResponse(String httpContent) {
    throw UnimplementedError();
  }
}
