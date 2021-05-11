/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: processing_result.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

import '../core/core.dart';
import '../src/xml_utils.dart';

///Stores processing information to a service request.
class ProcessingResult extends ResponseData {
  /// Error code of a request. 1 means that processing of request was a success.
  ///
  /// Use the service operation getCodes to get the possible values as well the
  /// meaning.
  final int code;

  /// A translated description of an error. Use [lcid] to determine the language.
  final String? description;

  /// The error level of [ProcessingResult].
  ///
  /// 1 means OK, 2 means the code is a warning and 3 means that there is a
  /// error.
  final int status;

  ///Create a custom [ProcessingResult]
  const ProcessingResult(this.code, this.description, this.status);

  /// Used to create [ProcessingResult] from a service response.
  factory ProcessingResult.fromXml(XmlElement element) {
    final code = element.extractValue<int>('Code', animalTracingNameSpace);

    final description = element.extractValue<String>(
        'Description', animalTracingNameSpace,
        isNillable: true);

    final status = element.extractValue<int>('Status', animalTracingNameSpace);

    return ProcessingResult(code!, description, status!);
  }
}

/// Is used to make the testing code more succinct without polluting
/// [EarTagOrderData] with code which could only be helpful in limited scenarios.
@visibleForTesting
extension ProcessingResultTestHelp on ProcessingResult {
  @visibleForTesting
  bool areSame(ProcessingResult other) {
    return other is ProcessingResult &&
        code == other.code &&
        description == other.description &&
        status == other.status;
  }
}
