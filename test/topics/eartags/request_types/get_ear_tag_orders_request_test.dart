/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: get_ear_tag_orders_request_test.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/eartags.dart';
import 'package:test/test.dart';

import '../../../test_utils/test_utils.dart';

void main() {
  group('GetEarTagOrdersRequest', () {
    test('builds valid xml', () async {
      await expectGeneratesValidXml(
          GetEarTagOrdersRequest(
              'Test', 1, 100, DateTime(1), DateTime(2), [0, 1, 2]),
          null);

      await expectGeneratesValidXml(
          GetEarTagOrdersRequest(null, 1, 100, DateTime(1), DateTime(2), []),
          null);
    });
  });
}
