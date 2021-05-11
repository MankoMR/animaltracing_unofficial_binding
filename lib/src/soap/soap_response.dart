/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: soap_response.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'package:xml/xml.dart';

import '../../exceptions/soap_exception.dart';
import '../../exceptions/xml_missing_element_exception.dart';
import '../xml_utils.dart';

/// SoapResponse is the parsed content of an soap:Envelope.
class SoapResponse {
  /// Contains the message for a service operation.
  late final XmlElement body;

  /// Might contain some metadata in addition to the message.
  late final XmlElement? header;

  /// Tries to parse [envelope] as soap:Envelope and does some
  /// preliminary checks.
  ///
  /// It will throw [XmlParseException] or [XmlMissingElementException] if [envelope] is not a valid soap:Envelope
  /// according the following [specification][spec].
  ///
  /// It will throw [SoapException] according to the Exception-Model of the library.
  ///
  /// [spec]: https://www.w3.org/2003/05/soap-envelope/
  SoapResponse(String envelope) {
    final XmlDocument document;
    document = XmlDocument.parse(envelope);
    final rootElement = document.rootElement;
    if (rootElement.name.namespaceUri != soapNameSpace &&
        rootElement.name.local != 'Envelope') {
      throw XmlMissingElementException('Envelope', soapNameSpace, null);
    }
    header = rootElement.getElement('Header', namespace: soapNameSpace);
    final supposedBody =
        rootElement.getElement('Body', namespace: soapNameSpace);
    if (supposedBody == null) {
      throw XmlMissingElementException('Body', soapNameSpace, null);
    } else {
      body = supposedBody;
    }
    _throwIfContainsFault(body);
  }

  /// Checks if soap:Body contains a fault-message. If it has one throws it
  /// as a [SoapException].
  ///
  /// If soap:Fault exists and it doesn't contain the soap:Reason element,
  /// it will throw a [XmlParseException].
  static void _throwIfContainsFault(XmlElement body) {
    final faultElement = body.getElement('Fault', namespace: soapNameSpace);
    if (faultElement != null) {
      final faultReason = faultElement
          .getElement('Reason', namespace: soapNameSpace)
          ?.getElement('Text', namespace: soapNameSpace)
          ?.innerText;
      //FaultCode is optional because the service does not always returns it.
      final faultCode = faultElement
          .getElement('Code', namespace: soapNameSpace)
          ?.getElement('Value', namespace: soapNameSpace)
          ?.innerText;
      if (faultReason == null) {
        throw XmlMissingElementException('Reason or Text', soapNameSpace, null);
      } else {
        throw SoapException(faultCode, faultReason);
      }
    }
  }
}
