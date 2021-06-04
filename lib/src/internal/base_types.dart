/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: base_types.dart
 * Projekt animaltracing_unofficial_binding.
 */

import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

import '../../animaltracing_unofficial_binding.dart';

/// Base class for all Topics.
///
/// Specifies how to get the [ConnectionConfiguration]
abstract class TopicBase {
  ///Contains necessary information for connecting to a service-endpoint.
  ///
  /// See [ConnectionConfiguration] for more information.
  ConnectionConfiguration get connectionConfiguration;
}

/// Base class which must be implemented by all data types which can be sent
/// with a request.
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
  // ignore: avoid_unused_constructor_parameters
  factory ResponseData.fromXml(XmlElement element) {
    throw UnimplementedError(
        'call constructor from classes which extend or implement from '
        'ResponseData');
  }
}
