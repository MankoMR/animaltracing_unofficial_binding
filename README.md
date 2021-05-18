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
May throw the following exceptions: 
* SocketException: Will be thrown if there are issues with connecting to a service.
* SoapException: Will be thrown if the soap:Envelope of response 
  to a service-operation contains a soap:Fault. 
* HttpException: If the status code is something other than OK. (If the http-content 
  can be parsed as soap:Envelope with a soap:Fault, a SoapException will be thrown instead.)
  
Those exception require special attention as they signal some issue that the library is unable to
handle.

If an error occurred while parsing, an Exception that implements
FormatException will be thrown. Here some examples what exceptions may
be thrown: 
* StringDecodingException
* XmlParserException
* XmlMissingElementException

Please note that in certain situations other Exceptions than listed above can be thrown.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/MankoMR/animaltracing_unofficial_binding/issues



## Coding-Style

See [analyis_options](analysis_options.yaml) for which lints will be used. 

###AVOID public late final fields without initializers.

Unlike other final fields, a late final field without an initializer does define a setter. If that field is public, then the setter is public. This is rarely what you want. Fields are usually marked late so that they can be initialized internally at some point in the instance’s lifetime, often inside the constructor body.

Unless you do want users to call the setter, it’s better to pick one of the following solutions:

 * Don’t use late.
 * Use late, but initialize the late field at its declaration.
 * Use late, but make the late field private and define a public getter for it.
