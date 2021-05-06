A library to interact with AnimalTracing.

AnimalTracing is a Service which allows interaction with the Animal Traffic Database.
For now aim of this project is to implement the following service operations:
* WriteNewEarTagOrder
* GetEarTagOrders
* DeleteEarTagOrder


Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
main() {
}
```

## Exception-Model
The library is expected to throw the following Exceptions:
* SoapException: Will be thrown if the soap:Envelope of response 
  to a service-operation contains a soap:Fault. 
* XmlParseException: Will be thrown if the received XML is invalid.
* XmlMissingElemenException: Will be thrown if a required XmlElement is not found
* FormatException: Will be thrown if some content of an element can't be parsed to a specific type.
* HttpException: If the status code is something other than OK. (If the http-content can be parsed
  as soap:Envelope with a soap:Fault, a SoapException will be thrown instead.)

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/MankoMR/animaltracing_unofficial_binding/issues
