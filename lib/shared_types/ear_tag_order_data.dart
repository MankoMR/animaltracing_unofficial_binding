/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: ear_tag_order_data.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/src/xml_utils.dart';
import 'package:xml/xml.dart';

import '../core/core.dart';

class EarTagOrderData extends ResponseData {
  final BigInt notificationId;
  final int earTagType;
  final int amount;
  final bool isExpress;
  final int orderStatus;
  final DateTime orderStatusDate;
  final String? earTagNumberFrom;
  final String? earTagNumberTo;
  final String? text1;
  final String? text2;

  EarTagOrderData(
      this.notificationId,
      this.earTagType,
      this.amount,
      this.isExpress,
      this.orderStatus,
      this.orderStatusDate,
      this.earTagNumberFrom,
      this.earTagNumberTo,
      this.text1,
      this.text2);

  factory EarTagOrderData.fromXml(XmlElement element) {
    final notificationId =
        extractValue<BigInt>(element, 'NotificationID', animalTracingNameSpace);

    final earTagType =
        extractValue<int>(element, 'EarTagType', animalTracingNameSpace);

    final amount = extractValue<int>(element, 'Amount', animalTracingNameSpace);

    final isExpress =
        extractValue<bool>(element, 'IsExpress', animalTracingNameSpace);

    final orderStatus =
        extractValue<int>(element, 'OrderStatus', animalTracingNameSpace);

    final orderStatusDate = extractValue<DateTime>(
        element, 'OrderStatusDate', animalTracingNameSpace);

    final earTagNumberFrom = extractValue<String>(element, 'EarTagNumberFrom',
        animalTracingNameSpace, NullabilityType.nullable);

    final earTagNumberTo = extractValue<String>(element, 'EarTagNumberTo',
        animalTracingNameSpace, NullabilityType.nullable);

    final text1 = extractValue<String>(
        element, 'Text1', animalTracingNameSpace, NullabilityType.nullable);

    final text2 = extractValue<String>(
        element, 'Text2', animalTracingNameSpace, NullabilityType.nullable);

    return EarTagOrderData(
        notificationId!,
        earTagType!,
        amount!,
        isExpress!,
        orderStatus!,
        orderStatusDate!,
        earTagNumberFrom,
        earTagNumberTo,
        text1,
        text2);
  }
}
