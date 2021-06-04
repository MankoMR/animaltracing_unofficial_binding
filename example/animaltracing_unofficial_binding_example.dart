import 'package:animaltracing_unofficial_binding/animaltracing_unofficial_binding.dart';
import 'package:animaltracing_unofficial_binding/eartags.dart';

Future<void> main() async {
  //configure options that are usually persistent over all calls to the endpoint
  final config = ConnectionConfiguration(
      endpoint: Uri.http('localhost:4040', 'Livestock/AnimalTracing/3'));
  //Create a topic which stores the config and uses it for all calls on the
  // topic Eartags.
  final eartagOps = Eartags(config);
  //Gather all necessary information to call a specific service operation.
  final requestData = GetEarTagOrdersRequest('manufacturerKey', 2055, 123456789,
      DateTime.now().subtract(const Duration(days: 330)), DateTime.now(), []);
  //Call getEarTagOrders with requestData and the authorization Token of
  // the user.
  try {
    final response = await eartagOps.getEarTagOrders(requestData, 'auth Token');

    //Do something with the response
    // ignore: avoid_print
    print('Response: Status: ${response.result?.status}, '
        'Desc: ${response.result?.description}, '
        'ErrorCode: ${response.result?.code}');
    printDetails(response.resultDetails);
    //Handle exceptions that can happen.
  } on SoapException catch (expection) {
    // ignore: avoid_print
    print(expection);
  } on Exception catch (exception, stacktrace) {
    // ignore: avoid_print
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
  // ignore: avoid_print
  print(buffer.toString());
  buffer.clear();
}
