/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: get_ear_tag_orders_request.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:xml/src/xml/builder.dart';

import '../core/core.dart';
import '../src/xml_utils.dart';

class GetEarTagOrdersRequest extends RequestData {
  final String? manufacturerKey;
  final int lcid;
  final int tvdNumber;
  final DateTime searchDateFrom;
  final DateTime searchDateTo;
  final List<int> articleFilter;

  GetEarTagOrdersRequest(this.manufacturerKey, this.lcid, this.tvdNumber,
      this.searchDateFrom, this.searchDateTo, this.articleFilter);
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
