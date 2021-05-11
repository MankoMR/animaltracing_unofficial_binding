/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: namespaces.dart
 * Project: animaltracing_unofficial_binding.
 */

import '../soap/soap_request.dart';

/// Contains the used xml-namespaces from AnimalTracing.
class Namespaces {
  ///Namespace for soap:Envelope
  static const String soap = 'http://www.w3.org/2003/05/soap-envelope';

  ///Namespace used in [SoapRequest] to define where and which operation is
  /// called.
  static const String addressing = 'http://www.w3.org/2005/08/addressing';

  ///Most Xml-Element are define in [animalTracing]
  static const String animalTracing =
      'http://www.admin.ch/xmlns/Services/evd/Livestock/AnimalTracing/1';

  ///Required for the ml-Attribute 'nil'
  //I had to look at code from the mockservice to get the correct namespace for
  // the Xml-Attribute 'nil'
  static const schemaInstance = 'http://www.w3.org/2001/XMLSchema-instance';

  ///Used to define name of a namespace.
  static const nameSpacesNames = {
    soap: 'soap',
    addressing: 'wsa',
    animalTracing: 'tns',
    schemaInstance: 'sch'
  };
}
