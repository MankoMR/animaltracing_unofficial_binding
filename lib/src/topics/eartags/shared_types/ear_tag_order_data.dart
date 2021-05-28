/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: ear_tag_order_data.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

import '../../../internal/base_types.dart';
import '../../../internal/xml_utils/parsing.dart';

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

  /// Custom text which appears (generally first?) on eartags.
  final String? text1;

  /// Custom text which appears (generally after [text1]) on eartags.
  final String? text2;

  ///Creates [EarTagOrderData] with custom information.
  const EarTagOrderData(
      this.notificationId,
      this.earTagType,
      this.amount,
      // This will be fixed in another rewrite.
      // ignore: avoid_positional_boolean_parameters
      this.isExpress,
      this.orderStatus,
      this.orderStatusDate,
      this.earTagNumberFrom,
      this.earTagNumberTo,
      this.text1,
      this.text2);

  /// Used to create [EarTagOrderData] from a service response.
  factory EarTagOrderData.fromXml(XmlElement element) {
    final notificationId = element.extractPrimitiveValue<BigInt>(
        'NotificationID', Namespaces.animalTracing);

    final earTagType = element.extractPrimitiveValue<int>(
        'EarTagType', Namespaces.animalTracing);

    final amount =
        element.extractPrimitiveValue<int>('Amount', Namespaces.animalTracing);

    final isExpress = element.extractPrimitiveValue<bool>(
        'IsExpress', Namespaces.animalTracing);

    final orderStatus = element.extractPrimitiveValue<int>(
        'OrderStatus', Namespaces.animalTracing);

    final orderStatusDate = element.extractPrimitiveValue<DateTime>(
        'OrderStatusDate', Namespaces.animalTracing);

    final earTagNumberFrom = element.extractPrimitiveValue<String>(
        'EarTagNumberFrom', Namespaces.animalTracing,
        isNullable: true);

    final earTagNumberTo = element.extractPrimitiveValue<String>(
        'EarTagNumberTo', Namespaces.animalTracing,
        isNullable: true);

    final text1 = element.extractPrimitiveValue<String>(
        'Text1', Namespaces.animalTracing,
        isNullable: true);

    final text2 = element.extractPrimitiveValue<String>(
        'Text2', Namespaces.animalTracing,
        isNullable: true);

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
/// [EarTagOrderData] with code which could only be helpful in limited
/// scenarios.
@visibleForTesting
extension EarTagOrderDataResultTestHelp on EarTagOrderData {
  @visibleForTesting

  /// Checks if this [EarTagOrderData] has the same values as the [other].
  bool areSame(EarTagOrderData other) =>
      other is EarTagOrderData &&
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

  /// Returns a String with the information stored in [EarTagOrderData].
  String toStringRepresentation() =>
      '$EarTagOrderData{id: $notificationId, type:$earTagType, '
      'amt:$amount, exprs:$isExpress, status: $orderStatus, '
      'stDate:$orderStatusDate, from:$earTagNumberFrom, to:$earTagNumberTo, '
      'txt1:$text1, txt2:$text2}';
}
