import 'package:animaltracing_unofficial_binding/animaltracing_unofficial_binding.dart';
import 'package:animaltracing_unofficial_binding/src/internal/xml_utils/parsing.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('Parsing:', () {
    group('ValidationChecksExtension', () {
      group('.nullabilityPass', () {
        test('returns null in appropriate Situations', () {
          final elementWithNil = XmlElement(
            XmlName('test'),
            [
              XmlAttribute(
                  XmlName(
                      Namespaces.nameSpacesNames[Namespaces.schemaInstance]!,
                      'xmlns'),
                  Namespaces.schemaInstance),
              XmlAttribute(
                  XmlName('nil',
                      Namespaces.nameSpacesNames[Namespaces.schemaInstance]),
                  'true'),
            ],
          );
          expect(elementWithNil.nullabilityPass('test', '', isNullable: true),
              isNull);
          const XmlElement? optionalElement = null;
          expect(optionalElement.nullabilityPass('test', '', isOptional: true),
              isNull);
        });
        test('returns XmlElement in appropriate Situations', () {
          final element = XmlElement(XmlName('test'));
          expect(element.nullabilityPass('test', ''), same(element));
        });
        test('throws MissingXmlElement in appropriate Situations', () {
          const XmlElement? nullElement = null;
          expect(() => nullElement.nullabilityPass('test', 'test'),
              throwsA(const TypeMatcher<XmlMissingElementException>()));
        });
      });
    });
  });
}
