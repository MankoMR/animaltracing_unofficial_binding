/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: integrations_test.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'package:animaltracing_unofficial_binding/animaltracing_unofficial_binding.dart';
import 'package:animaltracing_unofficial_binding/eartags.dart';
import 'package:test/test.dart';

void main() {
  group('Integration Tests', () {
    final endPointConfiguration = ConnectionConfiguration(
        endpoint: Uri.http('localhost:4040', 'Livestock/AnimalTracing/3'));
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
        expect(response.resultDetails.length, 2);
        expect(response.resultDetails.first.notificationId, BigInt.one);
        expect(response.resultDetails.first.amount, 7);
      });
    });
  }, tags: ['integration-test'], skip: true);
}
