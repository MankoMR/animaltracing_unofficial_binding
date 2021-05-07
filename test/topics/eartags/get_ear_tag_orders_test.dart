/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: get_ear_tag_orders_test.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/request_types/get_ear_tag_orders_request.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

void main() {
  group('GetEarTagOrders Operation', () {
    test('GetEarTagOrdersRequest builds valid xml', () async {
      await expectIsValidXml(
          GetEarTagOrdersRequest('Test', 1, 100, DateTime(1), DateTime(2), [2]),
          null);

      await expectIsValidXml(
          GetEarTagOrdersRequest(null, 1, 100, DateTime(1), DateTime(2), [2]),
          null);
    });
  });
}
