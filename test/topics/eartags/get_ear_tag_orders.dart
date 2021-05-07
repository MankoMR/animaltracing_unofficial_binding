/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: get_ear_tag_orders.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/request_types/get_ear_tag_orders_request.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../test_utils.dart';

void main() {
  group('GetEarTagOrders Operation', () {
    test('GetEarTagOrdersRequest is builds valid xml', () {
      expect(
          () async => await validDateRequestData(
              GetEarTagOrdersRequest(
                  'Test', 1, 100, DateTime(1), DateTime(2), [2]),
              null),
          returnsNormally);
      expect(
          () async => await validDateRequestData(
              GetEarTagOrdersRequest(
                  null, 1, 100, DateTime(1), DateTime(2), [2]),
              null),
          returnsNormally);
    });
  });
}
