/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: generation.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'package:xml/xml.dart';

import '../../core/core.dart';
import 'shared.dart';

export 'shared.dart';

/// Helper functions  to simplify generating xml in classes which
/// implement [RequestData].
extension XmlBuilding on RequestData {
  void buildNullableElement(
    XmlBuilder builder,
    String elementName,
    String namespace,
    NullabilityType nullabilityType,
    Object? value,
  ) {
    if (value == null) {
      switch (nullabilityType) {
        case NullabilityType.optionalElement:
          return;
        case NullabilityType.nullable:
          builder.element(
            elementName,
            namespace: namespace,
            nest: () {
              //I had to look at code from the mockservice to get the correct
              // Xml-Attribute name for element which are marked with
              // nillable="true" in the wsdl-Definition file
              //and the specific namespace in schemaInstanceNameSpace
              builder.attribute('nil', 'true',
                  namespace: Namespaces.schemaInstance);
            },
          );
          break;
        case NullabilityType.required:
          throw UnsupportedError(
              'Should not be called with a nullabilityType set to required');
      }
    } else {
      builder.element(elementName, namespace: namespace, nest: value);
    }
  }
}

/*
///May be used in code that will be implemented later. Used as reference.
typedef ItemBuilder<T> = void Function(XmlBuilder builder, T value);
void buildList<T>(
  XmlBuilder builder,
  String elementName,
  String namespace,
  NullabilityType nullabilityType,
  List<T>? values,
  ItemBuilder<T> itemBuilder,
) {
  if (values == null) {
    builder.element(
      elementName,
      namespace: namespace,
      nest: () {
        builder.attribute('isNill', 'true');
      },
    );
  } else {
    builder.element(elementName, namespace: namespace, nest: () {
      for (final value in values) {
        itemBuilder(builder, value);
      }
    });
  }
}
 */
