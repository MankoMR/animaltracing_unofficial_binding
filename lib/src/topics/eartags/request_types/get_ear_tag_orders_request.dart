/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: get_ear_tag_orders_request.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'package:xml/xml.dart';

import '../../../internal/base_types.dart';
import '../../../internal/xml_utils/generation.dart';

/// Holds the necessary information to call [Eartags.getEarTagOrders].
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
        namespace: Namespaces.animalTracing,
        namespaces: Namespaces.nameSpacesNames, nest: () {
      builder
        ..nullableElement('p_ManufacturerKey',
            namespace: Namespaces.animalTracing,
            nest: manufacturerKey,
            nullability: NullabilityType.nullable)
        ..element('p_LCID', namespace: Namespaces.animalTracing, nest: lcid)
        ..element('p_TVDNumber',
            namespace: Namespaces.animalTracing, nest: tvdNumber)
        ..element('p_SearchDateFrom',
            namespace: Namespaces.animalTracing,
            nest: searchDateFrom.toIso8601String())
        ..element('p_SearchDateTo',
            namespace: Namespaces.animalTracing,
            nest: searchDateTo.toIso8601String())
        ..elementList<int>(
          'p_ArticleFilter',
          namespace: Namespaces.animalTracing,
          nullability: NullabilityType.required,
          list: articleFilter,
          itemBuilder: (builder, articleType) {
            builder.element('IntItem',
                namespace: Namespaces.animalTracing, nest: articleType);
          },
        );
    });
  }
}
