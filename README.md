# animaltracing_inoficial_binding

A library to interact with AnimalTracing.

AnimalTracing is a Service which allows interaction with the Animal Traffic Database.
For now aim of this project is to implement the following service operations:

* WriteNewEarTagOrder
* GetEarTagOrders
* DeleteEarTagOrder

## License

No License Granted, all Rights reserved. Do not use this Code in any way, without permission.

Repository was initialized with a template available under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE) by running
`dart create -t package-simple animaltracing_unofficial_binding`. Code that is different
than the original templated code is not licensed under the BSD-style License.
See [init-repository](https://github.com/MankoMR/animaltracing_unofficial_binding/pull/1) for more
details.

Before I want to make the library publicly available, some work needs to be done:

* Decide which License will be used.
* Add templates for issues and pullrequests.
* Copy/Make development guidelines  available on the repository.
## Example

An example for how to call a service operation. The code is also available under
`example/animaltracing_unofficial_binding_example.dart`.

```dart
import 'package:animaltracing_unofficial_binding/animaltracing_unofficial_binding.dart';
import 'package:animaltracing_unofficial_binding/eartags.dart';

Future<void> main() async {
  //configure options that are usually persistent over all calls to the endpoint
  final config = ConnectionConfiguration(
      endpoint: Uri.http('localhost:4040', 'Livestock/AnimalTracing/3'));
  //Create a topic which stores the config and uses it for all calls on the topic Eartags.
  final eartagOps = Eartags(config);
  //Gather all necessary information to call a specific service operation.
  final requestData = GetEarTagOrdersRequest('manufacturerKey', 2055, 123456789,
      DateTime.now().subtract(const Duration(days: 330)), DateTime.now(), []);
  //Call getEarTagOrders with requestData and the authorization Token of the user.
  try {
    final response = await eartagOps.getEarTagOrders(requestData, 'auth Token');

    //Do something with the response
    print('Response: Status: ${response.result?.status}, '
        'Desc: ${response.result?.description}, '
        'ErrorCode: ${response.result?.code}');
    printDetails(response.resultDetails);
  //Handle exceptions that can happen.
  } on SoapException catch (expection) {
    print(expection);
  } on Exception catch (exception, stacktrace) {
    print('$exception\nStacktrace:\n$stacktrace');
  }
}

void printDetails(List<EarTagOrderData> details) {
  final buffer = StringBuffer('\n\nDetails:\n');
  for (final order in details) {
    buffer
      ..write('EartagOrder: Id: ')
      ..write(order.notificationId)
      ..write(', EartagType: ')
      ..write(order.earTagType)
      ..write(', ')
      ..write(order.isExpress ? 'Express Delivery' : '');
    //etc...
  }
  print(buffer.toString());
  buffer.clear();
}
```

## Exception-Model

May throw the following exceptions:

* SocketException: Will be thrown if there are issues with connecting to a service.
  Examples: No Internet Connection, Server is not available etc.
* SoapException: Will be thrown if the soap:Envelope of response
  to a service-operation contains a soap:Fault.
* HttpException: If the status code is something other than OK. (If the http-content
  can be parsed as soap:Envelope with a soap:Fault, a SoapException will be thrown instead.)
  Example: 404 Not found
  
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

For now there is not a standardized way to file feature request or bugs.
But contact me if you want to cooperate.

## Coding-Style

See [analyis_options](analysis_options.yaml) for which lints will be used.
All lints will enforced even if they are only informational. Only opt out of a lint,
when it impossible to enforce it.

Examples:

* ignore: avoid_print: In example code as print is purposely used to hold code simple.
* ignore: lines_longer_than_80_chars: when writing Todos in comments. Makes a regex on Todos easier.
* ignore: inference_failure_on_instance_creation: A lint can't be enforced in a sane way.
  See `test/internal/soap_client/io_client_test.dart:17`
* ignore: avoid_unused_constructor_parameters: Ignored to as constructor serves as example what
  signature must be by classes that implement the base class.
  See `lib/src/internal/base_types.dart:53`

Some Candidate Lints that might be stopped to be enforced:

* lines_longer_than_80_chars
