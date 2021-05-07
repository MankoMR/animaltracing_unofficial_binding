/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: test_utils.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'dart:io';

import 'package:animaltracing_unofficial_binding/core/core.dart';
import 'package:xml/xml.dart';

/// A mock implementation of a type used for making a request.
class MockRequestData extends RequestData {
  @override
  void generateWith(XmlBuilder builder, String? elementName) {
    builder.element(elementName ?? 'MockRequestData', nest: 'testData');
  }
}

