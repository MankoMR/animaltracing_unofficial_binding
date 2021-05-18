/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: integrations_test.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'package:animaltracing_unofficial_binding/core/core.dart';
import 'package:animaltracing_unofficial_binding/request_types/get_ear_tag_orders_request.dart';
import 'package:animaltracing_unofficial_binding/topics/eartags.dart';
import 'package:test/test.dart';

void main() {
  group('Integration Tests', () {
    final endPointConfiguration = ServiceEndpointConfiguration(
        'localhost', 4040, '/Livestock/AnimalTracing/3', null);
    group('Eartags', () {
      test('getEarTagOrders can communicate with mock-service', () async {
        final eartagOperations = Eartags(endPointConfiguration);
        final parameters = GetEarTagOrdersRequest(
            'IPA2021_Koloska',
            2055,
            123456789,
            DateTime.now().subtract(const Duration(days: 300)),
            DateTime.now(),
            [1, 2]);
        final response = await eartagOperations.getEarTagOrders(parameters, '');
        expect(response.result?.status, 1);
        expect(response.resultDetails?.length, 2);
        expect(response.resultDetails?.first.notificationId, BigInt.one);
        expect(response.resultDetails?.first.amount, 7);
      });
    });
  }, tags: ['integration'], skip: true);
}
