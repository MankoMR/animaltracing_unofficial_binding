/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: processing_result.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:xml/xml.dart';

import '../core/core.dart';
import '../src/xml_utils.dart';

class ProcessingResult extends ResponseData {
  final int code;
  final String? description;
  final int status;

  ProcessingResult(this.code, this.description, this.status);

  factory ProcessingResult.fromXml(XmlElement element) {
    final code = element.extractValue<int>('Code', animalTracingNameSpace);

    final description = element.extractValue<String>(
        'Description', animalTracingNameSpace, NullabilityType.nullable);

    final status = element.extractValue<int>('Status', animalTracingNameSpace);

    return ProcessingResult(code!, description, status!);
  }
}
