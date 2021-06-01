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
          expect(
              elementWithNil.nullabilityPass('test', '',
                  isNullable: true, isOptional: false),
              isNull);
          const XmlElement? optionalElement = null;
          expect(
              optionalElement.nullabilityPass('test', '',
                  isNullable: false, isOptional: true),
              isNull);
        });
        test('returns XmlElement in appropriate Situations', () {
          final element = XmlElement(XmlName('test'));
          expect(
              element.nullabilityPass('test', '',
                  isNullable: false, isOptional: false),
              same(element));
        });
        test('throws MissingXmlElement in appropriate Situations', () {
          const XmlElement? nullElement = null;
          expect(
              () => nullElement.nullabilityPass('test', 'test',
                  isNullable: false, isOptional: false),
              throwsA(const TypeMatcher<XmlMissingElementException>()));
        }, tags: ['exception-model']);
      });
    });
    group('ValueExtractionExtension', () {
      group('.extractXmlElement', () {
        //Add test only when there are significant changes implementation. See
        //Documentation of function.
      });
      group('.extractPrimitiveValue', () {
        test('returns null in appropriate Situation', () {});
        group(
            'Parsing an empy String to an instance of T as done in '
            'extractPrimitiveValue<T> throws FormatException or returns null:',
            () {
          test('int parsing of empty String throws FormatException', () {
            const empty = '';
            expect(() => int.parse(empty), throwsFormatException);
          });
          test('BigInt parsing of empty String throws FormatException', () {
            const empty = '';
            expect(() => BigInt.parse(empty), throwsFormatException);
          });
          test('DateTime parsing of empty String throws FormatException', () {
            const empty = '';
            expect(() => DateTime.parse(empty), throwsFormatException);
          });
          test('bool parsing of empty String throws FormatException', () {
            expect(() => parseBool(''), throwsFormatException);
          });
        });
          });
        });
        group('of type Int', () {
          test('throws FormatException in appropriate Situation', () {
            void extractValue(
                    XmlElement element, String name, String nameSpace) =>
                element.extractPrimitiveValue<int>(name, nameSpace);

            testExtractValueThrowsFormatException(
                extractValue, (builder) => null);
            testExtractValueThrowsFormatException(
                extractValue, (builder) => 'NotANumber');
            testExtractValueThrowsFormatException(
                extractValue, (builder) => '123.4');
            testExtractValueThrowsFormatException(
                extractValue,
                (builder) => '123000000000000000'
                    '00000000000000000000000000000000000004');
          });
          test('returns correct Value', () {
            const childName = 'Test';
            const childNamespace = 'testSpace';
            const value = 123456789;
            final element = createElementWithNestedValue(
                childName, childNamespace, (builder) => value);
            expect(
                element.extractPrimitiveValue<int>(childName, childNamespace),
                value);
          });
        });
        group('of type BigInt', () {
          test('throws FormatException in appropriate Situation', () {
            void extractValue(
                    XmlElement element, String name, String nameSpace) =>
                element.extractPrimitiveValue<BigInt>(name, nameSpace);

            testExtractValueThrowsFormatException(
                extractValue, (builder) => null);
            testExtractValueThrowsFormatException(
                extractValue, (builder) => 'NotANumber');
            testExtractValueThrowsFormatException(
                extractValue, (builder) => '123.4');
          });
          test('returns correct Value', () {
            const childName = 'Test';
            const childNamespace = 'testSpace';
            final value = BigInt.from(12321321312312);
            final element = createElementWithNestedValue(
                childName, childNamespace, (builder) => value);
            expect(
                element.extractPrimitiveValue<BigInt>(
                    childName, childNamespace),
                value);
          });
        });
        group('of type DateTime', () {
          test('throws FormatException in appropriate Situation', () {
            void extractValue(
                    XmlElement element, String name, String nameSpace) =>
                element.extractPrimitiveValue<BigInt>(name, nameSpace);

            testExtractValueThrowsFormatException(
                extractValue, (builder) => null);
            testExtractValueThrowsFormatException(
                extractValue, (builder) => 'NotADate');
            testExtractValueThrowsFormatException(extractValue,
                (builder) => '20210000000000000000-04-26T13:56:46');
          });
          test('returns correct Value', () {
            const childName = 'Test';
            const childNamespace = 'testSpace';
            final value = DateTime.now();
            final element = createElementWithNestedValue(childName,
                childNamespace, (builder) => value.toIso8601String());
            expect(
                element.extractPrimitiveValue<DateTime>(
                    childName, childNamespace),
                value);
          });
        });
        group('of type bool', () {
          test('throws FormatException in appropriate Situation', () {
            void extractValue(
                    XmlElement element, String name, String nameSpace) =>
                element.extractPrimitiveValue<bool>(name, nameSpace);

            testExtractValueThrowsFormatException(
                extractValue, (builder) => null);
            testExtractValueThrowsFormatException(
                extractValue, (builder) => 'NotABool');
            testExtractValueThrowsFormatException(
                extractValue, (builder) => 'tr ue');
          });
          test('returns correct Value', () {
            const childName = 'Test';
            const childNamespace = 'testSpace';
            const value = true;
            final element = createElementWithNestedValue(
                childName, childNamespace, (builder) => value);
            expect(
                element.extractPrimitiveValue<bool>(childName, childNamespace),
                equals(value));
          });
        });
      });
    });
  });
}

void testExtractValueThrowsFormatException(
    void Function(XmlElement, String childName, String childNameSpace)
        parsingStep,
    Object? Function(XmlBuilder) childNest) {
  const childName = 'Test';
  const childNamespace = 'testSpace';
  final element =
      createElementWithNestedValue(childName, childNamespace, childNest);
  expect(() => parsingStep(element, childName, childNamespace),
      throwsFormatException);
}

XmlElement createElementWithNestedValue(String childName, String childNameSpace,
    Object? Function(XmlBuilder) childNest,
    {String parentName = 'RootElement', String? rootNameSpace}) {
  final builder = XmlBuilder();
  builder.element(parentName, namespace: rootNameSpace, namespaces: {
    ...Namespaces.nameSpacesNames,
    if (!Namespaces.nameSpacesNames.containsKey(childNameSpace))
      childNameSpace: 'childNs',
    if (rootNameSpace != null &&
        !Namespaces.nameSpacesNames.containsKey(childNameSpace))
      rootNameSpace: 'rootNs',
  }, nest: () {
    builder.element(childName,
        namespace: childNameSpace, nest: childNest(builder));
  });

  return builder.buildDocument().rootElement;
}
