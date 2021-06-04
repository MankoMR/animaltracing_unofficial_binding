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
        //Add test only when there are significant changes to the
        // implementation. See Documentation of function and of nullabilityPass.
      });
      group('.extractPrimitiveValue', () {
        group(
            'Parsing an empty String to an instance of T as done in '
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
        group('Value Extraction works as intended:', () {
          test('throws UnsupportedError when T is not supported', () {
            final element = createElementWithValue(
                'Test', 'testSpace', (builder) => builder.text('value'));
            expect(
                // ignore: unnecessary_lambdas
                () => element.extractPrimitiveValue(),
                throwsUnsupportedError);
          });

          test(
              'Parsing element with not supported XML-Content throws '
              'FormatException', () {
            void runExtractionWithInjectedContent(String content) {
              final input = '<RootElement '
                  'xlmns:childNs="testSpace">val${content}ue</RootElement>';
              XmlDocument.parse(input)
                  .rootElement
                  .extractPrimitiveValue<String>();
            }

            //declaration
            expect(
                () => runExtractionWithInjectedContent("<?xml version='1.0'?>"),
                throwsFormatException);
            //doctype
            expect(() => runExtractionWithInjectedContent('<!DOCTYPE html>'),
                throwsFormatException);
            //processing instruction
            expect(() => runExtractionWithInjectedContent('<?pi test?>'),
                throwsFormatException);
            //element
            expect(() => runExtractionWithInjectedContent('<book>bla</book>'),
                throwsFormatException);
          });
          test('Parsing element with attributes does not throw', () {
            const value = 'value';
            final element = createElementWithValue(
                'Test',
                'testSpace',
                (builder) => builder
                  ..attribute('Attribute', 'attributeValue')
                  ..text(value));
            expect(element.extractPrimitiveValue<String>(), equals(value));
          });
          test(
              'Throws FormatException when element is empty and element '
              'contains no text', () {
            final element =
                createElementWithValue('Test', 'testSpace', (builder) {});

            expect(() => element.extractPrimitiveValue<String>(),
                throwsFormatException);
          });
          test(
              'Parsing element with content separated by XML-Comment returns '
              'correct value', () {
            const value = 'value';
            final element = createElementWithValue(
                'Test',
                'testSpace',
                (builder) => builder
                  ..attribute('Attribute', 'attributeValue')
                  ..text('val')
                  ..comment('commentText')
                  ..text('ue'));

            expect(element.extractPrimitiveValue<String>(), equals(value));
          });
          test(
              'Parsing element with mixed elements (TextElement or CDATA) '
              'returns correct value', () {
            const value = 'value';
            final element = createElementWithValue(
                'Test',
                'testSpace',
                (builder) => builder
                  ..attribute('Attribute', 'attributeValue')
                  ..text('val')
                  ..cdata('ue'));

            expect(element.extractPrimitiveValue<String>(), equals(value));
          });
        });
        group('of type Int', () {
          test('throws FormatException in appropriate Situation', () {
            void extractValue(XmlElement element) =>
                element.extractPrimitiveValue<int>();

            testExtractValueThrowsFormatException(extractValue, (builder) {});
            testExtractValueThrowsFormatException(
                extractValue, (builder) => builder.text('NotANumber'));
            testExtractValueThrowsFormatException(
                extractValue, (builder) => builder.text('123.4'));
            testExtractValueThrowsFormatException(
                extractValue,
                (builder) => builder.text('123000000000000000'
                    '00000000000000000000000000000000000004'));
          });
          test('returns correct Value', () {
            const value = 123456789;
            final element = createElementWithValue(
                'Test', 'testSpace', (builder) => builder.text(value));
            expect(element.extractPrimitiveValue<int>(), equals(value));
          });
        });
        group('of type BigInt', () {
          test('throws FormatException in appropriate Situation', () {
            void extractValue(XmlElement element) =>
                element.extractPrimitiveValue<BigInt>();

            testExtractValueThrowsFormatException(extractValue, (builder) {});
            testExtractValueThrowsFormatException(
                extractValue, (builder) => builder.text('NotANumber'));
            testExtractValueThrowsFormatException(
                extractValue, (builder) => builder.text('123.4'));
          });
          test('returns correct Value', () {
            final value = BigInt.from(12321321312312);
            final element = createElementWithValue(
                'Test', 'testSpace', (builder) => builder.text(value));
            expect(element.extractPrimitiveValue<BigInt>(), equals(value));
          });
        });
        group('of type DateTime', () {
          test('throws FormatException in appropriate Situation', () {
            void extractValue(XmlElement element) =>
                element.extractPrimitiveValue<BigInt>();

            testExtractValueThrowsFormatException(extractValue, (builder) {});
            testExtractValueThrowsFormatException(
                extractValue, (builder) => builder.text('NotADate'));
            testExtractValueThrowsFormatException(
                extractValue,
                (builder) =>
                    builder.text('20210000000000000000-04-26T13:56:46'));
          });
          test('returns correct Value', () {
            final value = DateTime.now();
            final element = createElementWithValue('Test', 'testSpace',
                (builder) => builder.text(value.toIso8601String()));
            expect(element.extractPrimitiveValue<DateTime>(), equals(value));
          });
        });
        group('of type bool', () {
          test('throws FormatException in appropriate Situation', () {
            void extractValue(XmlElement element) =>
                element.extractPrimitiveValue<bool>();

            testExtractValueThrowsFormatException(
                extractValue, (builder) => null);
            testExtractValueThrowsFormatException(
                extractValue, (builder) => 'NotABool');
            testExtractValueThrowsFormatException(
                extractValue, (builder) => 'tr ue');
          });
          test('returns correct Value', () {
            const value = true;
            final element = createElementWithValue(
                'Test', 'testSpace', (builder) => builder.text(value));
            expect(element.extractPrimitiveValue<bool>(), equals(value));
          });
        });
      });
      group('.extractNestedPrimitiveValue', () {
        // Add more tests if implementation changes. See extractXmlElement,
        // extractPrimitiveValue and function itself
        test('extracts value of specified Element', () {
          const childName = 'Child';
          const namespace = 'TestNamespace';
          const value = 'TestValue';
          final element = createElementWithValue('Test', namespace, (builder) {
            builder
              ..element('FirstChild', namespace: namespace, nest: 'OtherValue')
              ..element(childName, namespace: namespace, nest: value)
              ..element('LastChild', namespace: namespace, nest: 'OtherValue');
          });
          expect(
              element.extractNestedPrimitiveValue<String>(childName, namespace),
              equals(value));
        });
      });
      group('.extractList', () {
        test('extracts correct values', () {
          const rootName = 'Test';
          const nameSpace = 'testNs';
          const itemName = 'Int';
          final builder = XmlBuilder();
          builder.element(rootName,
              namespace: nameSpace,
              namespaces: {nameSpace: 'childNs'}, nest: () {
            builder
              ..element(itemName, namespace: nameSpace, nest: '1')
              ..element(itemName, namespace: nameSpace, nest: '2')
              ..comment('TestComment')
              ..cdata('TestCdata')
              ..text('TestText')
              ..element(itemName, namespace: nameSpace, nest: '3');
          });
          final rootElement = builder.buildDocument().rootElement;

          final list = rootElement.extractList<int>(itemName, nameSpace,
              (element) => element.extractPrimitiveValue<int>()!);
          expect(list, equals([1, 2, 3]),
              reason: '${rootElement.toXmlString(pretty: true)}\nlist: $list');
        });
        test('ignores children not of type XmlElement', () {
          const rootName = 'Test';
          const nameSpace = 'testNs';
          const itemName = 'Int';
          final builder = XmlBuilder();
          builder.element(rootName,
              namespace: nameSpace,
              namespaces: {nameSpace: 'childNs'}, nest: () {
            builder
              ..element(itemName, namespace: nameSpace, nest: '1')
              ..element(itemName, namespace: nameSpace, nest: '2')
              ..comment('TestComment')
              ..cdata('TestCdata')
              ..text('TestText')
              ..element(itemName, namespace: nameSpace, nest: '3');
          });
          final rootElement = builder.buildDocument().rootElement;

          final list = rootElement.extractList<int>(itemName, nameSpace,
              (element) => element.extractPrimitiveValue<int>()!);

          expect(list.length, equals(3),
              reason: '${rootElement.toXmlString(pretty: true)}\nlist: $list');
        });
        test('returns empty list if not items could be parsed', () {
          const rootName = 'Test';
          const nameSpace = 'testNs';
          const itemName = 'Int';
          final builder = XmlBuilder();
          builder.element(rootName,
              namespace: nameSpace,
              namespaces: {nameSpace: 'childNs'}, nest: () {
            builder
              ..comment('TestComment')
              ..cdata('TestCdata')
              ..text('TestText');
          });
          final rootElement = builder.buildDocument().rootElement;

          final list = rootElement.extractList<int>(itemName, nameSpace,
              (element) => element.extractPrimitiveValue<int>()!);

          expect(list.length, equals(0),
              reason: '${rootElement.toXmlString(pretty: true)}\nlist: $list');
        });
      });
    });
  });
}

void testExtractValueThrowsFormatException(
    void Function(XmlElement element) parsingStep,
    void Function(XmlBuilder) nest) {
  final element = createElementWithValue('Test', 'http://test.com', nest);
  expect(() => parsingStep(element), throwsFormatException);
}

XmlElement createElementWithValue(
    String name, String namespace, void Function(XmlBuilder) nest) {
  final builder = XmlBuilder();
  builder.element(name,
      namespace: namespace,
      namespaces: {
        ...Namespaces.nameSpacesNames,
        if (!Namespaces.nameSpacesNames.containsKey(namespace))
          namespace: 'testNs',
      },
      nest: () => nest(builder));

  return builder.buildDocument().rootElement;
}
