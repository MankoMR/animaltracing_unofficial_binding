/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: get_ear_tag_orders_request.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/topics/eartags.dart';
import 'package:xml/src/xml/builder.dart';

import '../core/core.dart';
import '../src/xml_utils.dart';

/// Holds the necessary information to call [getEarTagOrders] in [Eartags].
class GetEarTagOrdersRequest extends RequestData {
  /// The [manufacturerKey] to identify which program calls an operation.
  final String? manufacturerKey;

  /// The language id to define in which language a response should be written.
  final int lcid;

  /// The identification number of a farm. The returned eartag-orders are from
  /// the corresponding farm.
  final int tvdNumber;

  /// Eartag-orders made before the date are filtered out.
  ///
  /// The time span between [searchDateFrom] and [searchDateTo] must be less
  /// than one year.
  final DateTime searchDateFrom;

  /// Eartag-orders made after the date are filtered out.
  ///
  /// The time span between [searchDateFrom] and [searchDateTo] must be less
  /// than one year.
  final DateTime searchDateTo;

  /// Filters the returned eartag orders to be only of the eartag type included
  /// int [articleFilter]
  ///
  /// If no article type is added to [articleFilter] all types of eartags will
  /// be returned.
  final List<int> articleFilter;

  /// Creates [GetEarTagOrdersRequest] with all the necessary information.
  ///
  /// See the fields to find out how to use it.
  GetEarTagOrdersRequest(this.manufacturerKey, this.lcid, this.tvdNumber,
      this.searchDateFrom, this.searchDateTo, this.articleFilter);

  /// Generates the corresponding xml to this type.
  ///
  /// If method is overwritten by a library user, call [super.generateWith]
  /// to keep generating the required xml.
  @override
  void generateWith(XmlBuilder builder, String? elementName) {
    builder.element(elementName ?? 'GetEarTagOrders',
        namespace: animalTracingNameSpace,
        namespaces: nameSpaceMapping, nest: () {
      buildNullableElement(builder, 'p_ManufacturerKey', animalTracingNameSpace,
          NullabilityType.nullable, manufacturerKey);

      builder.element('p_LCID', namespace: animalTracingNameSpace, nest: lcid);

      builder.element('p_TVDNumber',
          namespace: animalTracingNameSpace, nest: tvdNumber);

      builder.element('p_SearchDateFrom',
          namespace: animalTracingNameSpace,
          nest: searchDateFrom.toIso8601String());

      builder.element('p_SearchDateTo',
          namespace: animalTracingNameSpace,
          nest: searchDateTo.toIso8601String());

      builder.element(
        'p_ArticleFilter',
        namespace: animalTracingNameSpace,
        nest: () {
          for (final articleType in articleFilter) {
            builder.element('IntItem',
                namespace: animalTracingNameSpace, nest: articleType);
          }
        },
      );
    });
  }
}
