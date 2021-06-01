/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: generation.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'package:xml/xml.dart';

import '../base_types.dart';
import 'shared.dart';

export 'shared.dart';

/// Implementers of this Function have to generate the XML representation of T
/// according to the WSDL for AnimalTracing.
///
/// To generate the XML, [builder] should be used.
///
/// Function signature definition is used in [XmlBuilding.buildList] to generate
/// XML for a list of T.
typedef ItemXmlGenerator<T> = void Function(XmlBuilder builder, T value);

/// Helper functions  to simplify generating xml in classes which
/// implement [RequestData].
extension XmlBuilding on XmlBuilder {
  /// Adds an [XmlElement] to the call hierarchy of [builder].
  ///
  /// [name] and [namespace] determine name of the [XmlElement] to create,
  /// while [nest] is the content of the [XmlElement]. See [XmlBuilder.element]
  /// for more details as to what values should be assigned to  [nest].
  ///
  /// [nullability] determines how a null value is be handled. If its set
  /// to [NullabilityType.nullable], the created [XmlElement] gets the
  /// following attribute if [nest] is null: 'nil="true"'.
  ///
  /// If [nullability] is set to  [NullabilityType.optionalElement] and if
  /// [nest] is null, no [XmlElement] is created.
  ///
  /// [nullability] set to [NullabilityType.required] is not supported and
  /// throws an [UnsupportedError].
  ///
  void nullableElement(
    String name, {
    required String namespace,
    Object? nest,
    required NullabilityType nullability,
  }) {
    if (nest == null) {
      switch (nullability) {
        case NullabilityType.optionalElement:
          return;
        case NullabilityType.nullable:
          element(name, namespace: namespace, nest: () {
            attribute('nil', 'true', namespace: Namespaces.schemaInstance);
          });
          break;
        default:
          throw UnsupportedError(
              '$nullability is not supported by this Function.');
      }
    } else {
      element(name, namespace: namespace, nest: nest);
    }
  }

  /// Adds an [XmlElement] to the call hierarchy of [builder].
  ///
  /// [name] and [namespace] determine the name of the [XmlElement] that holds
  /// the content of the [list],
  /// while [itemBuilder] defines how an item from [list] is mapped to xml. See
  /// [ItemXmlGenerator].
  ///
  /// [nullability] determines how an empty [list] is handled:
  /// * If [nullability] is set to [NullabilityType.nullable] and [list] is
  ///   empty, the created [XmlElement] gets the following
  ///   attribute: 'nil="true"'.
  /// * If [nullability] is set to  [NullabilityType.optionalElement] and
  ///   [list] is empty, no [XmlElement] is created.
  /// * If [nullability] is set to [NullabilityType.required] and the [list]
  ///   is empty, an empty [XmlElement] is created.
  void elementList<T extends Object>(
    String name,
    String namespace, {
    required NullabilityType nullability,
    required List<T> list,
    required ItemXmlGenerator<T> itemBuilder,
  }) {
    if (list.isEmpty) {
      if (nullability == NullabilityType.required) {
        element(name, namespace: namespace);
      } else {
        nullableElement(name, namespace: namespace, nullability: nullability);
      }
    } else {
      nullableElement(name, namespace: namespace, nullability: nullability,
          nest: () {
        for (final item in list) {
          itemBuilder(this, item);
        }
      });
    }
  }
}

/// Defines Options for how to map a null value in dart to a null value in xml.
enum NullabilityType {
  /// The XmlElement is optional.
  ///
  /// If a Object is null, no corresponding [XmlElement] will be created.
  optionalElement,

  /// The XmlElement gets created but gets attribute 'nill' set to 'true'.
  ///
  /// It should not contain nested elements.
  nullable,

  /// The XmlElement is required to exist and have a value.
  required,
}
