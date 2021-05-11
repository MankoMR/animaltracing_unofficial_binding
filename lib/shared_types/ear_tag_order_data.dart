/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: ear_tag_order_data.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

import '../core/core.dart';
import '../src/xml_utils.dart';
import '../src/xml_utils/namespaces.dart';

/// Represents an eartag order from a farm.
///
/// Is often used by service operations in [Eartags].
class EarTagOrderData extends ResponseData {
  /// The identification number of an order.
  ///
  /// Is used as parameter in some service operations like deleteEarTagOrder.
  final BigInt notificationId;

  /// The eartag type of an order.
  ///
  /// The type documents for which animal and which kind of eartag is
  /// referenced.
  final int earTagType;

  /// How many eartags are ordered.
  final int amount;

  /// Wether the order will be sent faster than usual.
  final bool isExpress;

  /// In which stage of processing the order is.
  ///
  /// Shortly after the creation of an order, the order can be canceled. The
  /// [orderStatus] is a key piece in determining this.
  final int orderStatus;

  /// Time when the [orderStatus] got updated.
  final DateTime orderStatusDate;

  /// Defines the start of the first connected series.
  ///
  /// When possible eartagnumbers are given as connected series of numbers.
  final String? earTagNumberFrom;

  /// Defines the end of the first connected series.
  ///
  /// When possible eartagnumbers are given as connected series of numbers.
  final String? earTagNumberTo;
  final String? text1;
  final String? text2;

  ///Creates [EarTagOrderData] with custom information.
  const EarTagOrderData(
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

  /// Used to create [EarTagOrderData] from a service response.
  factory EarTagOrderData.fromXml(XmlElement element) {
    final notificationId = element.extractValue<BigInt>(
        'NotificationID', Namespaces.animalTracing);

    final earTagType =
        element.extractValue<int>('EarTagType', Namespaces.animalTracing);

    final amount =
        element.extractValue<int>('Amount', Namespaces.animalTracing);

    final isExpress =
        element.extractValue<bool>('IsExpress', Namespaces.animalTracing);

    final orderStatus =
        element.extractValue<int>('OrderStatus', Namespaces.animalTracing);

    final orderStatusDate = element.extractValue<DateTime>(
        'OrderStatusDate', Namespaces.animalTracing);

    final earTagNumberFrom = element.extractValue<String>(
        'EarTagNumberFrom', Namespaces.animalTracing,
        isNillable: true);

    final earTagNumberTo = element.extractValue<String>(
        'EarTagNumberTo', Namespaces.animalTracing,
        isNillable: true);

    final text1 = element.extractValue<String>(
        'Text1', Namespaces.animalTracing,
        isNillable: true);

    final text2 = element.extractValue<String>(
        'Text2', Namespaces.animalTracing,
        isNillable: true);

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

/// Is used to make the testing code more succinct without polluting
/// [EarTagOrderData] with code which could only be helpful in limited scenarios.
@visibleForTesting
extension EarTagOrderDataResultTestHelp on EarTagOrderData {
  @visibleForTesting
  bool areSame(EarTagOrderData other) {
    return other is EarTagOrderData &&
        notificationId == other.notificationId &&
        earTagType == other.earTagType &&
        amount == other.amount &&
        isExpress == other.isExpress &&
        orderStatus == other.orderStatus &&
        orderStatusDate.isAtSameMomentAs(other.orderStatusDate) &&
        earTagNumberFrom == other.earTagNumberFrom &&
        earTagNumberTo == other.earTagNumberTo &&
        text1 == other.text1 &&
        text2 == other.text2;
  }
}
